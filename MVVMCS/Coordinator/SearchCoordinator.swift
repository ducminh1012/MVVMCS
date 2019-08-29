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
    case searchSingleSelection([String], String, SearchFormRowType)
    case searchResult
    case back
}

class SearchCoordinator: NavigationCoordinator<SearchRoute> {
    var searchViewModel: SearchViewModel!
    var searchSingleSelectionViewModel: SearchSingleSelectionViewModel!
    
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
        case .searchSingleSelection(let options, let selected, let type):
            let controller = SearchSingleSelectionViewController.instantiate()
            searchSingleSelectionViewModel = SearchSingleSelectionViewModel(router: anyRouter, options: options, selected: selected, type: type)
            
            // handle make selection
            searchSingleSelectionViewModel.didSelectMake = { (make) in
                self.searchViewModel.didSelectMake?(make)
                self.searchSingleSelectionViewModel.router.trigger(.back)
            }
            
            // handle model selection
            searchSingleSelectionViewModel.didSelectModel = { model in
                self.searchViewModel.didSelectModel?(model)
                self.searchSingleSelectionViewModel.router.trigger(.back)
            }
            
            searchSingleSelectionViewModel.didSelectFromPrice = { fromPrice in
                self.searchViewModel.didSelectFromPrice?(fromPrice)
                self.searchSingleSelectionViewModel.router.trigger(.back)
            }
            
            searchSingleSelectionViewModel.didSelectToPrice = { toPrice in
                self.searchViewModel.didSelectToPrice?(toPrice)
                self.searchSingleSelectionViewModel.router.trigger(.back)
            }
            controller.bind(to: searchSingleSelectionViewModel)
            return .push(controller)
        case .searchResult:
            let searchResultController = SearchResultViewController.instantiate()
            return .push(searchResultController)
        case .back:
            return .pop()
        }
    }
}


