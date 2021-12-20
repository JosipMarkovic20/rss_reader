//
//  AppCoordinator.swift
//  RSS Reader
//
//  Created by Josip Marković on 20.12.2021..
//

import Foundation
import UIKit

class AppCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    
    init(window: UIWindow){
        self.window = window
    }
    
    func start() {
        let presenter = UINavigationController()
        window.rootViewController = presenter
        window.makeKeyAndVisible()
        createHomeCoordinator(presenter: presenter)
    }
    private func createHomeCoordinator(presenter: UINavigationController){
        let homeCoordinator = HomeCoordinator(navController: presenter)
        self.addChildCoordinator(coordinator: homeCoordinator)
        homeCoordinator.start()
    }
}

extension AppCoordinator: CoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        removeChildCoordinator(coordinator: self)
    }
}
