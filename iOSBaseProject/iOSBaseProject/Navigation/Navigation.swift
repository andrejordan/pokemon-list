//
//  Navigation.swift
//  iOSBaseProject
//
//  Created by Andre Jordan on 2023-01-20.
//

import UIKit

/** Used to navigate between screens in app*/
protocol Navigator {
    var navigationController: UINavigationController { get }
    func navigate(to screen: Screen)
    func start()
    func showAlert(title: String, message: String)
}

/** Concrete Implementation*/
class Navigation: Navigator {
    
    let navigationController: UINavigationController
    private let dependencies: IOCContainer
    private let initialScreen: Screen?
    
    init(dependencies: IOCContainer, initialScreen: Screen? = nil) {
        self.navigationController = .init()
        self.initialScreen = initialScreen
        self.dependencies = dependencies
    }
    
    func start() {
        guard let screen = initialScreen else { return }
        navigate(to: screen)
    }
    
    func navigate(to screen: Screen) {
        let viewController = screen.viewController(self, dependencies: dependencies)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default) { _ in
            alert.dismiss(animated: true)
        })
        navigationController.present(alert, animated: true)
    }
    

    
}
