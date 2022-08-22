//
//  Directions.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation
import GoogleMaps

struct Directions: Codable {
    let routes: [routeData?]?
}

struct routeData: Codable {
    let overview_polyline: [String: String]
}

struct DirectionData {
    let polyline: GMSPolyline
    let sourceMarker: GMSMarker
    let destinationMarker: GMSMarker
}
