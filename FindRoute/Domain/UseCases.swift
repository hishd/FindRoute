//
//  UseCases.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation
import CoreLocation

class GetLocationsUseCase {
    private let repository: LocationsRepository
    
    init(repository: LocationsRepository) {
        self.repository = repository
    }
    
    func execute(location: String, callback: @escaping (Result<[Location], Error>) -> Void) {
        repository.findLocations(contains: location, callback: callback)
    }
}

class GetDestinationsUseCase {
    private let repository: DirectionsRepository
    
    init(repository: DirectionsRepository) {
        self.repository = repository
    }
    
    func execute(fromCoordinate: CLLocationCoordinate2D, toCoordinate: CLLocationCoordinate2D, callback: @escaping (Result<Directions, Error>) -> Void) {
        repository.findDirections(from: fromCoordinate, to: toCoordinate, callback: callback)
    }
}
