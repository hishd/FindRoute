//
//  RouteViewViewModel.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation

class RouteViewViewModel: ObservableObject {
    @Published var fromLocation: String = "" {
        didSet {
            isSearchingDestinationLocations = false
            if fromLocation.isEmpty {
                isSearchingSourceLocations = false
            } else {
                isSearchingSourceLocations = true
                fetchSourceLocations(contains: fromLocation)
            }
        }
    }
    @Published var endLocation: String = "" {
        didSet {
            isSearchingSourceLocations = false
            if endLocation.isEmpty {
                isSearchingDestinationLocations = false
            } else {
                isSearchingDestinationLocations = true
                fetchDestinationLocations(contains: endLocation)
            }
        }
    }
    
    @Published var searchResults: [Location] = [
        Location(name: "Kadawatha", coordinates: nil),
        Location(name: "Mahara", coordinates: nil),
        Location(name: "Makola", coordinates: nil),
        Location(name: "Maradana", coordinates: nil),
        Location(name: "Gampaha", coordinates: nil),
        Location(name: "Naiwala", coordinates: nil),
    ]
    @Published var isSearchingSourceLocations = false
    @Published var isSearchingDestinationLocations = false
    
    @Published var selectedSourceLocation: Location? = nil {
        didSet {
            print("Selected location : \(selectedSourceLocation?.name ?? "Sample Source")")
        }
    }
    @Published var selectedDestinationLocation: Location? = nil {
        didSet {
            print("Selected location : \(selectedDestinationLocation?.name ?? "Sample Destination")")
        }
    }
    
    let getLocationsUseCase: GetLocationsUseCase
    
    init(getLocationsUseCase: GetLocationsUseCase) {
        self.getLocationsUseCase = getLocationsUseCase
    }
    
    private func fetchSourceLocations(contains text: String) {
        
    }
    
    private func fetchDestinationLocations(contains text: String) {
        
    }
}
