//
//  DIContainer.swift
//  FindRoute
//
//  Created by Hishara Dilshan on 2022-08-21.
//

import Foundation
import Swinject

class DIContainer {
    static let shared = DIContainer()
    private init() {}
    
    let container: Container = {
        let container = Container()
        container.register(LocationAPIService.self) { _ in
            GoogleLocationAPI.shared
        }
        container.register(LocationsRepository.self) { resolver in
            LocationsRepositoryComponent(service: resolver.resolve(LocationAPIService.self)!)
        }
        container.register(DirectionsRepository.self) { resolver in
            DirectionsRepositoryComponent(service: resolver.resolve(LocationAPIService.self)!)
        }
        container.register(GetLocationsUseCase.self) { resolver in
            GetLocationsUseCase(repository: resolver.resolve(LocationsRepository.self)!)
        }
        container.register(GetCoordinatesUseCase.self) { resolver in
            GetCoordinatesUseCase(repository: resolver.resolve(LocationsRepository.self)!)
        }
        container.register(GetDirectionsUseCase.self) { resolver in
            GetDirectionsUseCase(repository: resolver.resolve(DirectionsRepository.self)!)
        }
        container.register(RouteViewViewModel.self) { resolver in
            RouteViewViewModel(
                getLocationsUseCase: resolver.resolve(GetLocationsUseCase.self)!,
                getCoordinatesUseCase: resolver.resolve(GetCoordinatesUseCase.self)!,
                getDirectionsUseCase: resolver.resolve(GetDirectionsUseCase.self)!
            )
        }
        return container
    }()
}
