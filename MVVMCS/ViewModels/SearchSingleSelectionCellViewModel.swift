//
//  SearchSingleSelectionCellViewModel.swift
//  MVVMCS
//
//  Created by Duc Le on 8/28/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import RxCocoa

class SearchSingleSelectionCellViewModel {
    var title = BehaviorRelay(value: "")
    var value = BehaviorRelay(value: "All")
    var options = BehaviorRelay(value: [String]())
    
    init(title: String, options: [String], value: String) {
        self.title = BehaviorRelay(value: title)
        self.options = BehaviorRelay(value: options)
        self.value = BehaviorRelay(value: value)
    }
}
