//
//  Container.swift
//  iOSBaseProject
//
//  Created by Andre Jordan on 2023-01-20.
//

import Foundation
import UIKit

/** Dependency Injection container
    Provides necessary ViewModels and Services
*/
protocol IOCContainer {
    func resolve<T>(withNavigation navigation: Navigator?) -> T
}

final class DependencyContainer: IOCContainer {
    private var pokemonViewModel: PokemonViewModel? = nil
    private var pokemonService: PokemonService? = nil
    private var networkService: NetworkService? = nil
    
    func resolve<T>(withNavigation navigation: Navigator? = nil) -> T {
        print("Resolving service with \(T.self)")
        switch T.self {
        case is PokemonViewModel.Protocol:
            guard let nav = navigation, let vm = resolvePokemonViewModel(withNavigation: nav) as? T else {
                fatalError("Type \(T.self) not supported.")
            }
            return vm
        case is PokemonService.Protocol:
            guard let service = resolvePokemonService() as? T else {
                fatalError("Type \(T.self) not supported")
            }
            return service
        case is NetworkService.Protocol:
            guard let service = resolveNetworkService() as? T else {
                fatalError("Type \(T.self) not supported")
            }
            return service
        default:
            fatalError("Type \(T.self) not supported")
        }
    }
}

// MARK: ViewModels
fileprivate extension DependencyContainer {
    func resolvePokemonViewModel(withNavigation navigation: Navigator) -> PokemonViewModel {
        guard let viewModel = pokemonViewModel else {
            let viewModel = PokemonVM(navigation: navigation, service: resolvePokemonService())
            self.pokemonViewModel = viewModel
            return viewModel
        }
        return viewModel
    }
}

// MARK: Services
fileprivate extension DependencyContainer {
    func resolvePokemonService() -> PokemonService {
        guard let service = pokemonService else {
            let service = PokemonServiceImpl(service: resolveNetworkService())
            self.pokemonService = service
            return service
        }
        return service
    }
    
    func resolveNetworkService() -> NetworkService {
        guard let service = networkService else {
            let service = NetworkServiceURLSession()
            self.networkService = service
            return service
        }
        return service
    }
}
