//
//  Screen.swift
//  iOSBaseProject
//
//  Created by Andre Jordan on 2023-01-20.
//

import UIKit

/** The various in app screens we want to show */
enum Screen {
    case characterList
    
    /** Returns the correct UIViewController for that screen */
    func viewController(_ navigation: Navigator, dependencies: IOCContainer) -> UIViewController {
        switch self {
        case .characterList:
            return PokemonListViewController(withViewModel: dependencies.resolve(withNavigation: navigation))
        }
    }
}
