//
//  RouteViewViewModel.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation

class RouteViewViewModel: ObservableObject {
    @Published var fromLocation: String = ""
    @Published var endLocation: String = ""
}
