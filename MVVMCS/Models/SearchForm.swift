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
    
    let selectedMake = BehaviorRelay<String>(value: "All")
    let selectedModel = BehaviorRelay<String>(value: "All")
    
    let selectedFromPrice = BehaviorRelay<String>(value: "All")
    let selectedToPrice = BehaviorRelay<String>(value: "All")
    
    let allSections = BehaviorRelay<[SearchSection]>(value: [])
    
    init() {}
    
    func toDictionary() -> [String: String] {
        return [
            "make": selectedMake.value,
            "model": selectedModel.value,
            "price_from": selectedFromPrice.value,
            "price_to": selectedToPrice.value
        ]
    }
}
