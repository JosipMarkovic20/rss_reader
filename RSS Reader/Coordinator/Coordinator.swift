//
//  Coordinator.swift
//  RSS Reader
//
//  Created by Josip Marković on 20.12.2021..
//

import Foundation
import UIKit

protocol Coordinator: AnyObject{
    var childCoordinators: [Coordinator] {get set}
    
    func start()
}

extension Coordinator{
    func addChildCoordinator(coordinator: Coordinator){
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(coordinator: Coordinator){
        childCoordinators = childCoordinators.filter{ $0 !== coordinator}
    }
}
