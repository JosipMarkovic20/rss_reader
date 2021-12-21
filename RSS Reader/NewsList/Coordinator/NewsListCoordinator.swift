//
//  NewsListCoordinator.swift
//  RSS Reader
//
//  Created by Josip Marković on 21.12.2021..
//

import Foundation
import UIKit

class NewsListCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var newsListController: NewsListViewController!
    var childCoordinators: [Coordinator] = []
    var parentDelegate: ParentCoordinatorDelegate?
    
    init(navController: UINavigationController, news: News) {
        navigationController = navController
        super.init()
        newsListController = createNewsListController(news: news)
    }
    
    deinit{
        print("Deinit: \(self)")
    }
    
    func start() {
        navigationController.pushViewController(newsListController, animated: true)
    }

    func createNewsListController(news: News) -> NewsListViewController {
        let viewModel = NewsListViewModelImpl(dependencies: NewsListViewModelImpl.Dependencies(news: news))
        let viewController = NewsListViewController(viewModel: viewModel)
        return viewController
    }
}
extension NewsListCoordinator: CoordinatorDelegate, ParentCoordinatorDelegate{
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        parentDelegate?.childHasFinished(coordinator: self)
    }
    
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(coordinator: coordinator)
    }
}
