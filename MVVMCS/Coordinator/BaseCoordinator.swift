//
//  Coordinator.swift
//  MVVMCS
//
//  Created by Duc Le on 8/2/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit

protocol Coordinator : class {
    var childCoordinators : [Coordinator] { get set }
    func start()
}

extension Coordinator {
    
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

class BaseCoordinator : Coordinator {
    var childCoordinators : [Coordinator] = []
    var isCompleted: (() -> Void)?
    
    func start() {
        fatalError("Children should implement `start`.")
    }
}

class AppCoordinator : BaseCoordinator {
    
    let window : UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    override func start() {
        // preparing root view
        let navigationController = UINavigationController()
        let searchCoordinator = SearchCoordinator(navigationController: navigationController)
        
        // store child coordinator
        self.store(coordinator: searchCoordinator)
        searchCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // detect when free it
        searchCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: searchCoordinator)
        }
    }
}
