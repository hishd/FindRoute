//
//  FindRouteApp.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import SwiftUI
import GoogleMaps

@main
struct FindRouteApp: App {
    
    init() {
        if let keysPListPath = Bundle.main.url(forResource: "apikeys", withExtension: "plist") {
            do {
                let keysData = try Data(contentsOf: keysPListPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: keysData, options: [], format: nil) as? [String: String] {
                    print("Reading keys")
                    print(dict)
                    guard let mapsApiKey = dict["maps_key"] else {
                        print("Could not find Google Maps API Key")
                        return
                    }
                    GMSServices.provideAPIKey(mapsApiKey)
                }
            } catch {
                print("Could not find keys plist file")
            }
        }
    }
    
    let viewModel = DIContainer.shared.container.resolve(RouteViewViewModel.self)
    
    var body: some Scene {
        WindowGroup {
            if let viewModel = viewModel {
                RouteView(viewModel: viewModel)
            }
        }
    }
}
