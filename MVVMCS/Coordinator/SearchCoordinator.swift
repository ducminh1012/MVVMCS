//
//  SearchCoordinator.swift
//  MVVMCS
//
//  Created by Duc Le on 8/5/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit

class SearchCoordinator : BaseCoordinator {

    var navigationController: UINavigationController?
    let viewModel = SearchViewModel()
    
    init(navigationController :UINavigationController?) {
        self.navigationController = navigationController
    }

    override func start() { 
        let viewController = SearchViewController.instantiate()
        viewController.viewModel = viewModel
        viewController.coordinator = self

        navigationController?.pushViewController(viewController, animated: true)
    }

    func showDetail(index: IndexPath, in navigationController: UINavigationController, callback: @escaping (SearchRow) -> Void) {
        let detailViewModel = viewModel.detailViewModel(at: index)

        detailViewModel.didUpdateTitle = callback
        
        let newCoordinator = SearchDetailCoordinator(navigationController: navigationController, viewModel: detailViewModel)
        self.store(coordinator: newCoordinator)
        newCoordinator.start()
        
    }
}
