//
//  LocationAPIService.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation
import CoreLocation
import Combine

protocol LocationAPIService {
    func findLocations(contains text: String) -> Future<[Location], Error> 
    func getDirections(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> Future<Directions, Error>
}
