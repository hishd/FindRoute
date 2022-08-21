//
//  RouteViewViewModel.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation

class RouteViewViewModel: ObservableObject {
    @Published var sourceLocationQuery: String = "" {
        didSet {
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
    }
    @Published var destinationLocationQuery: String = "" {
        didSet {
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
    }
    
    @Published var searchResults: [Location] = []
    @Published var isSearchingSourceLocations = false
    @Published var isSearchingDestinationLocations = false
    
    @Published var selectedSourceLocation: Location? = nil {
        didSet {
            isSearchingSourceLocations = false
            print("Selected location : \(selectedSourceLocation?.name ?? "Sample Source")")
            if let location = selectedSourceLocation {
                sourceLocationQuery = location.name
            }
        }
    }
    @Published var selectedDestinationLocation: Location? = nil {
        didSet {
            isSearchingDestinationLocations = false
            print("Selected location : \(selectedDestinationLocation?.name ?? "Sample Destination")")
            if let location = selectedDestinationLocation {
                destinationLocationQuery = location.name
            }
        }
    }
    
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    let getLocationsUseCase: GetLocationsUseCase
    let getCoordinatesUseCase: GetCoordinatesUseCase
    ///DispatchWorkItem API is used inorder to avoid unnecessary API calls on each character changes
    var checkSourceLoationWorkItem: DispatchWorkItem?
    var checkDestinationWorkItem: DispatchWorkItem?
    
    init(getLocationsUseCase: GetLocationsUseCase, getCoordinatesUseCase: GetCoordinatesUseCase) {
        self.getLocationsUseCase = getLocationsUseCase
        self.getCoordinatesUseCase = getCoordinatesUseCase
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
    
    private func fetchSourceLocations(contains text: String) {
        DispatchQueue.main.async {
            self.searchResults = []
        }
        checkSourceLoationWorkItem?.cancel()
        let workItem: DispatchWorkItem = DispatchWorkItem {
            print("Searching Source : \(text)")
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
            print("Searching Destination : \(text)")
            self.getLocationsUseCase.execute(location: text, callback: self.fetchDestinationCallback)
        }
        checkDestinationWorkItem = workItem
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: workItem)
    }
    
    func handleSearchRoute() {
        guard let sourceLocation = selectedSourceLocation, let destinationLocation = selectedDestinationLocation else {
            self.isError = true
            self.errorMessage = "Please select both Start & End Location"
            return
        }
        
        self.isError = false
        
        getCoordinatesUseCase.execute(sourceID: sourceLocation.id, destinationID: destinationLocation.id) { result in
            switch result {
            case .success(let locationCoordinates):
                print(locationCoordinates)
            case .failure(let error):
                self.isError = true
                self.errorMessage = error.localizedDescription
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
