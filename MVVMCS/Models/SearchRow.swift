//
//  SearchRow.swift
//  AutoScout24
//
//  Created by Duc Le on 4/1/19.
//  Copyright © 2019 Scout24.ch. All rights reserved.
//

import UIKit
import RxCocoa

typealias Parameter = (title: String, options: [String], value: String?)

enum SearchRowType {
    case single
    case fromTo
}

struct SearchRow {
    var index: Int!
    var type = SearchRowType.single
    var params = BehaviorRelay<[Parameter]>(value: [])
    
    static func single(params: [Parameter]) -> SearchRow {
        return SearchRow(type: .single, params: params)
    }
    
    static func fromTo(from: Parameter, to: Parameter) -> SearchRow {
        return SearchRow(type: .fromTo, params: [from, to])
    }
    
    init(type: SearchRowType, params: [Parameter]) {
        self.type = type
        self.params = BehaviorRelay(value: params)
    }
    
    init(){
    }
}
