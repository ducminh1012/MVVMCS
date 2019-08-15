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
    var selectedMake = BehaviorRelay<String>(value: "")
    var selectedModel = BehaviorRelay<String>(value: "")
    
    var allSections = BehaviorRelay<[SearchSection]>(value: [])
    var makeSection = SearchSection(type: .makeModel, items: [])
    var priceSection = SearchSection(type: .price, items: [])
    
    init() {
        reloadData()
    }
    
    func reloadData() {
        let makes = VehicleSearchService.shared.allMakes
        let models = VehicleSearchService.shared.models(for: selectedMake.value) ?? Parameter(title: "Models", options: [], value: nil)
        
        let yearFrom = Parameter(title: "Year", options: ["2019", "2018", "2017", "2016"], value: "2018")
        let yearTo = yearFrom
        
        let priceFrom = Parameter(title: "Price", options: ["CHF 1'000", "CHF 2'000", "CHF 3'000", "CHF 4'000", "CHF 5'000"], value: "CHF 3'000")
        let priceTo = priceFrom
        
        
        makeSection = SearchSection.makeModel(items: [
            SearchRow.single(params: [makes]),
            SearchRow.single(params: [models])
            ]
        )
        
        priceSection = SearchSection.price(items: [
            SearchRow.single(params: [yearFrom, yearTo]),
            SearchRow.single(params: [priceFrom, priceTo])
            ]
        )
        
        allSections = BehaviorRelay(value: [
            makeSection,
            priceSection
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
