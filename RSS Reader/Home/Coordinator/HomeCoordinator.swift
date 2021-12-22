//
//  HomeCoordinator.swift
//  RSS Reader
//
//  Created by Josip Marković on 20.12.2021..
//

import Foundation
import UIKit

class HomeCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var homeViewController: HomeViewController!
    var childCoordinators: [Coordinator] = []
    var parentDelegate: ParentCoordinatorDelegate?
    
    init(navController: UINavigationController) {
        navigationController = navController
        super.init()
        homeViewController = createHomeViewController()
    }
    
    deinit{
        print("Deinit: \(self)")
    }
    
    func start() {
        navigationController.pushViewController(homeViewController, animated: true)
    }

    func createHomeViewController() -> HomeViewController {
        let viewModel = HomeViewModelImpl(dependencies: HomeViewModelImpl.Dependencies(newsRepository: NewsRepositoryImpl(restManager: RESTManager())))
        let viewController = HomeViewController(viewModel: viewModel)
        viewController.delegate = self
        return viewController
    }
}
extension HomeCoordinator: CoordinatorDelegate, ParentCoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentDelegate?.childHasFinished(coordinator: self)
    }
    
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator: coordinator)
    }
}

extension HomeCoordinator: HomeNavigationDelegate {
    func navigateToNewsList(news: News) {
        let coordinator = NewsListCoordinator(navController: navigationController,
                                              news: news)
        addChildCoordinator(coordinator: coordinator)
        coordinator.parentDelegate = self
        coordinator.start()
    }
}


protocol HomeNavigationDelegate: AnyObject {
    func navigateToNewsList(news: News)
}
