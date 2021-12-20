//
//  ParentCoordinatorDelegate.swift
//  RSS Reader
//
//  Created by Josip Marković on 20.12.2021..
//

import Foundation

protocol ParentCoordinatorDelegate: AnyObject {
    func childHasFinished(coordinator: Coordinator)
}
