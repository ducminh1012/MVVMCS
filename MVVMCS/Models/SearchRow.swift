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
    var type = SearchRowType.single
    var title: String?
    var data = BehaviorRelay<[Parameter]>(value: [])
    
    static func single(title: String, data: [Parameter]) -> SearchRow {
        return SearchRow(type: .single, title: title, data: data)
    }
    
    static func fromTo(from: Parameter, to: Parameter) -> SearchRow {
        return SearchRow(type: .fromTo, title: nil, data: [from, to])
    }
    
    init(type: SearchRowType, title: String?, data: [Parameter]) {
        self.type = type
        self.title = title
        self.data = BehaviorRelay(value: data)
    }
    
    init(){
        
    }
}
