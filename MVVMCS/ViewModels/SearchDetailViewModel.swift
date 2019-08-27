//
//  SearchDetailViewModel.swift
//  MVVMCS
//
//  Created by Duc Le on 8/8/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//
import RxCocoa
import XCoordinator

class SearchDetailViewModel {
    let router: AnyRouter<SearchRoute>
    let rowData = BehaviorRelay(value: SearchRow())
    
    var didSelectMake: ((String) -> Void)?
    
    init(router: AnyRouter<SearchRoute>, rowData: SearchRow) {
        self.router = router
        self.rowData.accept(rowData)
    }
}
