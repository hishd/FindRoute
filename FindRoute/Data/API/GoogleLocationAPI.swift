//
//  GoogleLocationAPI.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation
import CoreLocation
import Combine
import GooglePlaces

class GoogleLocationAPI: LocationAPIService {
    
    static let shared = GoogleLocationAPI()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func findLocations(contains text: String) -> Future<[Location], Error> {
        return Future<[Location], Error> { promise in
            let filter = GMSAutocompleteFilter()
            filter.country = "LK"
            GMSPlacesClient.shared().findAutocompletePredictions(fromQuery: text, filter: filter, sessionToken: nil) { results, error in
                guard let results = results, error == nil else {
                    promise(.failure(LocationError.notLocations))
                    return
                }
                
                let locations: [Location] = results.compactMap { prediction in
                    Location(id: prediction.placeID, name: prediction.attributedFullText.string)
                }
                
                promise(.success(locations))
            }
        }
    }
    
    func findCoordinates(placeID: String) -> Future<CLLocationCoordinate2D, Error> {
        return Future<CLLocationCoordinate2D, Error> { promise in
            let placesClient = GMSPlacesClient.shared()
            
            placesClient.lookUpPlaceID(placeID) { place, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let place = place else {
                    promise(.failure(LocationError.noCoordinates(placeID)))
                    return
                }
                
                let coordinates = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                
                promise(.success(coordinates))
            }
        }
    }
    
    func getDirections(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> Future<Directions, Error> {
        return Future<Directions, Error> { [weak self] promise in
            
        }
    }
}

enum LocationError: Error {
    case notLocations
    case noDirections
    case noCoordinates(String)
    case unknown
    case invalid
}

extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notLocations:
            return NSLocalizedString("No locations found", comment: "No Locations")
        case .noDirections:
            return NSLocalizedString("No Direction data found", comment: "No Data")
        case .noCoordinates(let location):
            return NSLocalizedString("No Coordinates found for location : \(location)", comment: "No Coordinates")
        case .unknown:
            return NSLocalizedString("Unknown error occurred", comment: "Unknown Error")
        case .invalid:
            return NSLocalizedString("Invalid Input", comment: "Invalid Input")
        }
    }
}
