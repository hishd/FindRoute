//
//  LocationsRepository.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation

protocol LocationsRepository {
    func findLocations(contains text: String, callback: @escaping (Result<[Location], Error>) -> Void)
}
