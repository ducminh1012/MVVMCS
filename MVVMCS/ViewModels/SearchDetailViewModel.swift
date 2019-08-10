//
//  SearchDetailViewModel.swift
//  MVVMCS
//
//  Created by Duc Le on 8/8/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//
import RxCocoa

class SearchDetailViewModel {
    var rowData = BehaviorRelay<SearchRow>(value: SearchRow())
    
    var didUpdateTitle: ((SearchRow) -> Void)?
    
    init(row: SearchRow) {
        rowData.accept(row)
    }
}
