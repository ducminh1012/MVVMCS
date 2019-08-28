//
//  SearchSingleSelectionViewModel.swift
//  MVVMCS
//
//  Created by Duc Le on 8/8/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//
import RxCocoa
import XCoordinator

enum SearchFormRowType {
    case make
    case model
}

class SearchSingleSelectionViewModel {
    let router: AnyRouter<SearchRoute>
    let options: BehaviorRelay<[String]>
    let selectedValue: BehaviorRelay<String>
    let type: SearchFormRowType
    
    var didSelectMake: ((String) -> Void)?
    var didSelectModel: ((String) -> Void)?
    
    init(router: AnyRouter<SearchRoute>, options: [String], selected: String, type: SearchFormRowType) {
        self.router = router
        self.options = BehaviorRelay(value: options)
        self.selectedValue = BehaviorRelay(value: selected)
        self.type = type
    }
}
