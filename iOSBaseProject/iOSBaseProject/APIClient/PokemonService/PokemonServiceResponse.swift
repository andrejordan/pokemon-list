//
//  PokemonServiceResponse.swift
//  iOSBaseProject
//
//  Created by Karen Pinzas Morrongiello on 2022-01-06.
//

import Foundation

class PokemonServiceResponse: Codable {
	let count: Int
	let next: String?
	let previous: String?
	let results: [Pokemon]
}
