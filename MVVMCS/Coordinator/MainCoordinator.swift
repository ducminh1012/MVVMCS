//
//  MainCoordinator.swift
//  MVVMCS
//
//  Created by Duc Le on 10/21/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit
import XCoordinator

enum MainRoute: Route {
    case main
}
class MainCoordinator: NavigationCoordinator<MainRoute> {
    var navigationController: UINavigationController?

    init() {
        super.init(initialRoute: .main)
    }
    
    override func prepareTransition(for route: MainRoute) -> NavigationTransition {
        switch route {
        case .main:
            let viewController = MainViewController() // init programmatically
            viewController.modalPresentationStyle = .fullScreen
            return .set([viewController])
        }
    }
}
