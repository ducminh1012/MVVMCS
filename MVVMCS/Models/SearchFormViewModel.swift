//
//  SearchForm.swift
//  MVVMCS
//
//  Created by Duc Le on 8/6/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchFormViewModel {
    var form = Form()
    
    var allSections = BehaviorRelay<[SearchSection]>(value: [])
    var makeSection = SearchSection(type: .makeModel, items: [])
    var priceSection = SearchSection(type: .price, items: [])
    
    init() {
        reloadData()
    }
    
    func reloadData() {
        allSections = BehaviorRelay(value: [
            makeSection
        ])
    }
}

struct Model {
    var title: BehaviorRelay<String>
    var sections: BehaviorRelay<[FormSection]>
}

struct FormSection {
    var title: BehaviorRelay<String>
    var rows: BehaviorRelay<FormItem>
}

struct FormItem {
    var title: BehaviorRelay<String>
    var params: BehaviorRelay<[(String, String)]>
}
