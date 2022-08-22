//
//  DirectionsRepositoryComponent.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation
import CoreLocation
import Combine

class DirectionsRepositoryComponent: DirectionsRepository {
    
    private let service: LocationAPIService
    private var cancellables = Set<AnyCancellable>()
    
    init(service: LocationAPIService) {
        self.service = service
    }
    
    func findDirections(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, withKey apiKey: String, callback: @escaping (Result<Directions, Error>) -> Void) {
        service.getDirections(from: start, to: end, withKey: apiKey)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    callback(.failure(error))
                case .finished:
                    print("Directions data fetched")
                }
            } receiveValue: { directions in
                callback(.success(directions))
            }
            .store(in: &self.cancellables)
    }
}
