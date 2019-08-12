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

class SearchForm {
    
    var allSections = BehaviorRelay<[SearchSection]>(value: [])
    var makeSection = SearchSection(type: .makeModel, items: [])
    var priceSection = SearchSection(type: .price, items: [])
    
    init(sections: [SearchSection]) {
        allSections = BehaviorRelay(value: sections)
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
