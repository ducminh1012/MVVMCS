//
//  SearchFromToSelectionCellViewModel.swift
//  MVVMCS
//
//  Created by Duc Le on 8/28/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import RxCocoa

class SearchFromToSelectionCellViewModel {
    var fromValue = BehaviorRelay(value: "All")
    var toValue = BehaviorRelay(value: "All")
    
    var fromOptions = BehaviorRelay(value: [String]())
    var toOptions = BehaviorRelay(value: [String]())
    
    var didSelectFromButton: (() -> Void)?
    var didSelectToButton: (() -> Void)?
    
    init(fromOptions: [String], toOptions: [String], fromValue: String, toValue: String) {
        self.fromOptions = BehaviorRelay(value: fromOptions)
        self.toOptions = BehaviorRelay(value: toOptions)
        self.fromValue = BehaviorRelay(value: fromValue)
        self.toValue = BehaviorRelay(value: toValue)
    }
}
