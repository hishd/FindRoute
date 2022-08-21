//
//  FindRouteApp.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import SwiftUI

@main
struct FindRouteApp: App {
    
    init() {
        if let keysPListPath = Bundle.main.url(forResource: "apikeys", withExtension: "plist") {
            do {
                let keysData = try Data(contentsOf: keysPListPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: keysData, options: [], format: nil) as? [String: String] {
                    print("Reading keys")
                    print(dict)
                }
            } catch {
                print("Could not find keys plist file")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RouteView()
        }
    }
}
