//
//  SearchDetailCoordinator.swift
//  MVVMCS
//
//  Created by Duc Le on 8/2/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//
import UIKit

class SearchDetailCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var viewModel: SearchDetailViewModel?
    
    init(navigationController: UINavigationController, viewModel: SearchDetailViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let viewController = SearchDetailViewController.instantiate()
        viewController.viewModel = viewModel
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goBackHome() {
        navigationController.popViewController(animated: true)
        free(coordinator: self)
    }
}
