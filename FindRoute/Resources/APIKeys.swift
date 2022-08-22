//
//  APIKeys.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-23.
//

import Foundation

class ApiKeys {
    static let shared = ApiKeys()
    private init() {}
    
    var mapsKey: String?
}
