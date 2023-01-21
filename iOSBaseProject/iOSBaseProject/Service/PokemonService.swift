//
//  PokemonService.swift
//  iOSBaseProject
//
//  Created by Andre Jordan on 2023-01-20.
//

import Foundation

protocol PokemonService {
    func getPokemonList(paginate: Bool, completion: @escaping (Array<Pokemon>?, Error?) -> ())
}

final class PokemonServiceImpl: PokemonService {
    
    private let networkService: NetworkService
    private var cachedResponse: PokemonServiceResponse?
    
    init(service: NetworkService) {
        self.networkService = service
        self.cachedResponse = nil
    }
    
    /** Fetches pokemon list*/
    func getPokemonList(paginate: Bool, completion: @escaping (Array<Pokemon>?, Error?) -> ()) {
        print("PokemonService: Getting Pokemon List")
        let endpoint = getEndpoint(paginate: paginate)
        networkService.fetch(endpoint: endpoint) { [weak self] (response: PokemonServiceResponse?, error: Error?) in
            if let error = error {
                print("Pokemon Service: Error fetching pokemon: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            guard let response = response else { return }
            print("PokemonService: Got Pokemon List Successfully")
            completion(response.results, nil)
            self?.cachedResponse = response
        }
    }
    
    /** Returns endpoint URL based on whether or not we should paginate*/
    private func getEndpoint(paginate: Bool) -> String {
        let baseURL = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=50"
        guard paginate, let cachedResponse = self.cachedResponse, let endpoint = cachedResponse.next else { return baseURL }
        return endpoint
    }
}


