//
//  SearchCoordinator.swift
//  MVVMCS
//
//  Created by Duc Le on 8/5/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit
import XCoordinator

enum SearchRoute: Route {
    case search
    case searchSingleSelection(SearchRow)
    case searchResult
    case back
}

class SearchCoordinator: NavigationCoordinator<SearchRoute> {
    var searchViewModel: SearchViewModel!
    var searchDetailViewModel: SearchDetailViewModel!
    
    init() {
        super.init(initialRoute: .search)
    }
    
    override func prepareTransition(for route: SearchRoute) -> NavigationTransition {
        switch route {
        case .search:
            let viewController = SearchViewController.instantiate()
            searchViewModel = SearchViewModel(router: anyRouter)
            viewController.bind(to: searchViewModel)
            return .push(viewController)
        case .searchSingleSelection(let rowData):
            let controller = SearchDetailViewController.instantiate()
            searchDetailViewModel = SearchDetailViewModel(router: anyRouter, rowData: rowData)
            searchDetailViewModel.didSelectMake = { (make) in
                self.searchViewModel.didSelectMake?(make)
            }
            controller.bind(to: searchDetailViewModel)
            return .push(controller)
        case .searchResult:
            return .none()
        case .back:
            return .pop()
        }
    }
}


