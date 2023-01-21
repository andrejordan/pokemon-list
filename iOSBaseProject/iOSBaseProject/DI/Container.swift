//
//  Container.swift
//  iOSBaseProject
//
//  Created by Andre Jordan on 2023-01-20.
//

import Foundation

/** Dependency Injection container
    Provides necessary ViewModels and Services
*/
protocol IOCContainer {
    func injectPokemonViewModel(withNavigation navigation: Navigator) -> PokemonViewModel
    func injectPokemonService() -> PokemonService
    func injectNetworkService() -> NetworkService
}

final class DependencyContainer: IOCContainer {
    private var pokemonViewModel: PokemonViewModel? = nil
    
    private var pokemonService: PokemonService? = nil
    private var networkService: NetworkService? = nil
}

// MARK: ViewModels
extension DependencyContainer {
    func injectPokemonViewModel(withNavigation navigation: Navigator) -> PokemonViewModel {
        guard let viewModel = pokemonViewModel else {
            let viewModel = PokemonVM(navigation: navigation, service: injectPokemonService())
            self.pokemonViewModel = viewModel
            return viewModel
        }
        return viewModel
    }
}

// MARK: Services
extension DependencyContainer {
    func injectPokemonService() -> PokemonService {
        guard let service = pokemonService else {
            let service = PokemonServiceImpl(service: injectNetworkService())
            self.pokemonService = service
            return service
        }
        return service
    }
    
    func injectNetworkService() -> NetworkService {
        guard let service = networkService else {
            let service = NetworkServiceURLSession()
            self.networkService = service
            return service
        }
        return service
    }
}
