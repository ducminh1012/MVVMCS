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
    
    let allSections = BehaviorRelay<[SearchSection]>(value: [])
    
    init() {}
}
