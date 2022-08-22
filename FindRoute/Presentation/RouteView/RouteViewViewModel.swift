//
//  RouteViewViewModel.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation
import GoogleMaps

class RouteViewViewModel: ObservableObject {
    @Published var sourceLocationQuery: String = "" {
        didSet {
            onSourceLocationQueryChanged()
        }
    }
    @Published var destinationLocationQuery: String = "" {
        didSet {
            onDestinationLocationQueryChanged()
        }
    }
    
    @Published var searchResults: [Location] = []
    @Published var isSearchingSourceLocations = false
    @Published var isSearchingDestinationLocations = false
    
    @Published var selectedSourceLocation: Location? = nil {
        didSet {
            onselectedSourceLocation()
        }
    }
    @Published var selectedDestinationLocation: Location? = nil {
        didSet {
            onSelectedDestinationLocation()
        }
    }
    
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var isRouteLoading: Bool = false
    
    let getLocationsUseCase: GetLocationsUseCase
    let getCoordinatesUseCase: GetCoordinatesUseCase
    let getDirectionsUseCase: GetDirectionsUseCase
    ///DispatchWorkItem API is used inorder to avoid unnecessary API calls on each character changes
    var checkSourceLoationWorkItem: DispatchWorkItem?
    var checkDestinationWorkItem: DispatchWorkItem?
    
    init(getLocationsUseCase: GetLocationsUseCase, getCoordinatesUseCase: GetCoordinatesUseCase, getDirectionsUseCase: GetDirectionsUseCase) {
        self.getLocationsUseCase = getLocationsUseCase
        self.getCoordinatesUseCase = getCoordinatesUseCase
        self.getDirectionsUseCase = getDirectionsUseCase
    }
    
    private lazy var fetchSourceCallback: (Result<[Location], Error>) -> (Void) = { result in
        switch result {
        case .success(let locations):
            DispatchQueue.main.async {
                self.searchResults = locations
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private lazy var fetchDestinationCallback: (Result<[Location], Error>) -> (Void) = { result in
        switch result {
        case .success(let locations):
            DispatchQueue.main.async {
                self.searchResults = locations
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

// MARK: Private Methods which handles ViewModel Operations
extension RouteViewViewModel {
    private func onSourceLocationQueryChanged() {
        guard selectedSourceLocation?.name != sourceLocationQuery else {
            return
        }
        isSearchingDestinationLocations = false
        if sourceLocationQuery.isEmpty {
            isSearchingSourceLocations = false
        } else {
            isSearchingSourceLocations = true
            fetchSourceLocations(contains: sourceLocationQuery)
        }
    }
    
    private func onDestinationLocationQueryChanged() {
        guard selectedDestinationLocation?.name != destinationLocationQuery else {
            return
        }
        isSearchingSourceLocations = false
        if destinationLocationQuery.isEmpty {
            isSearchingDestinationLocations = false
        } else {
            isSearchingDestinationLocations = true
            fetchDestinationLocations(contains: destinationLocationQuery)
        }
    }
    
    private func onselectedSourceLocation() {
        isSearchingSourceLocations = false
        print("Selected location : \(selectedSourceLocation?.name ?? "Sample Source")")
        if let location = selectedSourceLocation {
            sourceLocationQuery = location.name
        }
    }
    
    private func onSelectedDestinationLocation() {
        isSearchingDestinationLocations = false
        print("Selected location : \(selectedDestinationLocation?.name ?? "Sample Destination")")
        if let location = selectedDestinationLocation {
            destinationLocationQuery = location.name
        }
    }
    
    private func fetchSourceLocations(contains text: String) {
        DispatchQueue.main.async {
            self.searchResults = []
        }
        checkSourceLoationWorkItem?.cancel()
        let workItem: DispatchWorkItem = DispatchWorkItem {
            self.getLocationsUseCase.execute(location: text, callback: self.fetchSourceCallback)
        }
        checkSourceLoationWorkItem = workItem
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: workItem)
    }
    
    private func fetchDestinationLocations(contains text: String) {
        DispatchQueue.main.async {
            self.searchResults = []
        }
        checkDestinationWorkItem?.cancel()
        let workItem: DispatchWorkItem = DispatchWorkItem {
            self.getLocationsUseCase.execute(location: text, callback: self.fetchDestinationCallback)
        }
        checkDestinationWorkItem = workItem
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: workItem)
    }
}

// MARK: Methods which handles View Layer Actions
extension RouteViewViewModel {
    func handleSearchRoute(onDirectionsReady: @escaping (DirectionData) -> Void) {
        guard let sourceLocation = selectedSourceLocation, let destinationLocation = selectedDestinationLocation else {
            self.isError = true
            self.errorMessage = "Please select both Start & End Location"
            self.isRouteLoading = false
            return
        }
        
        self.isError = false
        
        getCoordinatesUseCase.execute(sourceID: sourceLocation.id, destinationID: destinationLocation.id) { result in
            switch result {
            case .success(let locationCoordinates):
                print(locationCoordinates)
                self.prepareDirections(locationCoordinates: locationCoordinates, onDirectionsReady: onDirectionsReady)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isError = true
                    self.errorMessage = error.localizedDescription
                    self.isRouteLoading = false
                }
            }
        }
    }
    
    private func prepareDirections(locationCoordinates: LocationCoordinates, onDirectionsReady: @escaping (DirectionData) -> Void) {
        guard let key = ApiKeys.shared.mapsKey else {
            print("Maps API Key not found")
            return
        }
        
        self.isError = false
        
        getDirectionsUseCase.execute(fromCoordinate: locationCoordinates.sourceCoordinates,
                                     toCoordinate: locationCoordinates.destinationCoordinates,
                                     withKey: key) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isError = true
                    self.errorMessage = error.localizedDescription
                    self.isRouteLoading = false
                    print(error)
                }
            case .success(let directions):
                ///Fetching the First Direction of the Route
                print("Loaded Routes data.....!")
                guard let firstDirection = directions.routes, let route = firstDirection.first else {
                    print("No Routes found")
                    DispatchQueue.main.async {
                        self.isError = true
                        self.errorMessage = "No Routes Found"
                        self.isRouteLoading = false
                    }
                    return
                }
                if let points = route?.overview_polyline["points"] {
                    let path = GMSPath.init(fromEncodedPath: points)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeColor = .systemBlue
                    polyline.strokeWidth = 5
                    
                    let sourceMarker = GMSMarker()
                    sourceMarker.position = locationCoordinates.sourceCoordinates
                    sourceMarker.title = "Start Trip"
                    
                    let destinationMarker = GMSMarker()
                    destinationMarker.position = locationCoordinates.destinationCoordinates
                    destinationMarker.title = "End Trip"
                    
                    onDirectionsReady(DirectionData(polyline: polyline, sourceMarker: sourceMarker, destinationMarker: destinationMarker))
                } else {
                    DispatchQueue.main.async {
                        self.isError = true
                        self.errorMessage = "Could not generate the route on map"
                        self.isRouteLoading = false
                    }
                }
            }
        }
    }
    
    func clearSourceLocation() {
        self.sourceLocationQuery = ""
        self.selectedSourceLocation = nil
    }
    
    func clearDestinationLocation() {
        self.destinationLocationQuery = ""
        self.selectedDestinationLocation = nil
    }
}
