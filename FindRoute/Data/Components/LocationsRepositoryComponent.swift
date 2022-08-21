//
//  LocationsRepositoryComponent.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation
import CoreLocation
import Combine

class LocationsRepositoryComponent: LocationsRepository {
    
    private let service: LocationAPIService
    private var cancellables = Set<AnyCancellable>()
    
    init(service: LocationAPIService) {
        self.service = service
    }
    
    func findLocations(contains text: String, callback: @escaping (Result<[Location], Error>) -> Void) {
        service.findLocations(contains: text)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    callback(.failure(error))
                case .finished:
                    print("Fetched Location Results")
                }
            } receiveValue: { locations in
                callback(.success(locations))
            }
            .store(in: &self.cancellables)
    }
}
