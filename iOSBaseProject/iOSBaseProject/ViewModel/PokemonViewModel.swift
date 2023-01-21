//
//  PokemonViewModel.swift
//  iOSBaseProject
//
//  Created by Andre Jordan on 2023-01-20.
//

import Foundation
import SwiftUI

typealias PokemonList = Array<Pokemon>

protocol PokemonViewModel {
    var isLoading: Bindable<Bool> { get }
    var pokemonList: Bindable<PokemonList> { get }
    func getPokemonList()
    func paginateIfNeeded(_ indexPath: Int)
}

final class PokemonVM: PokemonViewModel {
    
    // MARK: Bindable Observables
    var isLoading: Bindable<Bool> = Bindable(false)
    var pokemonList: Bindable<PokemonList> = Bindable([])
    
    // MARK: Dependencies
    private let navigation: Navigator
    private let pokemonService: PokemonService

    // MARK: Initializer
    init(navigation: Navigator, service: PokemonService) {
        self.pokemonService = service
        self.navigation = navigation
    }
    
    // MARK: Methods
    func getPokemonList() {
        self.getPokemon(paginate: false)
    }
    
    /** Fetches pokemon
        paginate: Bool - whether or not we should load the next page of pokemon
     */
    private func getPokemon(paginate: Bool = false) {
        self.isLoading.value = true
        self.pokemonService.getPokemonList(paginate: paginate) { [weak self] response, error in
            guard let self = self else { return }
            self.isLoading.value = false
            
            guard error == nil else {
                self.navigation.showAlert(title: "Error Loading Pokemon", message: "Please try again")
                return
            }
            
            guard let response = response else { return }
            self.pokemonList.value.append(contentsOf: response)
        }
    }
    
    /** Determines if we need to load the next page of pokemon based on the current indexPath*/
    func paginateIfNeeded(_ indexPath: Int) {
        let numberOfPokemon = self.pokemonList.value.count
        guard indexPath == numberOfPokemon - 1 else { return }
        print("PokemonViewModel: Reached Last Item. Pagination Required")
        getPokemon(paginate: true)
    }
}
