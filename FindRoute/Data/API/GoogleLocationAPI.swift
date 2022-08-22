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
    
    func getDirections(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, withKey apiKey: String) -> Future<Directions, Error> {
        return Future<Directions, Error> { promise in
            let sourceLocation = String(format: "%f,%f", start.latitude, start.longitude)
            let destinationLocation = String(format: "%f,%f", end.latitude, end.longitude)
            
            guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json") else {
                promise(.failure(LocationError.unknown("Could not generate a valid URL")))
                return
            }
            
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "origin", value: sourceLocation),
                URLQueryItem(name: "destination", value: destinationLocation),
                URLQueryItem(name: "mode", value: "driving"),
                URLQueryItem(name: "key", value: apiKey),
            ]
            let resource = Resource(url: url, method: .get(queryItems))
            let service = HTTPWebService()
            
            Task {
                do {
                    let directions: Directions = try await service.load(resource)
                    promise(.success(directions))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}

enum LocationError: Error {
    case notLocations
    case noDirections
    case noCoordinates(String)
    case unknown(String?)
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
        case .unknown(let message):
            return NSLocalizedString(message ?? "Unknown error occurred", comment: "Unknown Error")
        case .invalid:
            return NSLocalizedString("Invalid Input", comment: "Invalid Input")
        }
    }
}
