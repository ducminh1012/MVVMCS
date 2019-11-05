//
//  Coordinator.swift
//  MVVMCS
//
//  Created by Duc Le on 8/2/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit
import XCoordinator

enum AppRoute: Route {
    case search
    case main
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    
    init() {
        super.init(initialRoute: .search)
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .search:
            let router = SearchCoordinator()
            router.rootViewController.modalPresentationStyle = .fullScreen
            return .present(router)
        case .main:
            let router = MainCoordinator()
            router.rootViewController.modalPresentationStyle = .fullScreen
            return .present(router)
        }
    }
}
