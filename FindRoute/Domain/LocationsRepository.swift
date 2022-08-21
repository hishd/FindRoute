//
//  LocationsRepository.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation
import CoreLocation

protocol LocationsRepository {
    func findLocations(contains text: String, callback: @escaping (Result<[Location], Error>) -> Void)
    func findLocationCoordinates(sourceID: String, destinationID: String, callback: @escaping (Result<LocationCoordinates, Error>) -> Void)
}

struct LocationCoordinates {
    let sourceCoordinates: CLLocationCoordinate2D
    let destinationCoordinates: CLLocationCoordinate2D
}
