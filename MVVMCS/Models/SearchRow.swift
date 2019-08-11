//
//  SearchRow.swift
//  AutoScout24
//
//  Created by Duc Le on 4/1/19.
//  Copyright © 2019 Scout24.ch. All rights reserved.
//

import UIKit
import RxCocoa

typealias Parameter = (title: String, data: [String], value: String?)

enum SearchRowType {
    case single
    case fromTo
}

struct SearchRow {
    var index: Int!
    var type = SearchRowType.single
    var title: String?
    var params = BehaviorRelay<[Parameter]>(value: [])
    
    static func single(title: String, options: [Parameter]) -> SearchRow {
        return SearchRow(type: .single, title: title, params: options)
    }
    
    static func fromTo(from: Parameter, to: Parameter) -> SearchRow {
        return SearchRow(type: .fromTo, title: nil, params: [from, to])
    }
    
    init(type: SearchRowType, title: String?, params: [Parameter]) {
        self.type = type
        self.title = title
        self.params = BehaviorRelay(value: params)
    }
    
    init(){
        
    }
}
