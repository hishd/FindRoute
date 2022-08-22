//
//  DestinationsRepository.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation
import CoreLocation

protocol DirectionsRepository {
    func findDirections(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, withKey apiKey: String, callback: @escaping (Result<Directions, Error>) -> Void)
}
