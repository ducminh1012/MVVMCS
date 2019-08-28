//
//  SearchRow.swift
//  AutoScout24
//
//  Created by Duc Le on 4/1/19.
//  Copyright © 2019 Scout24.ch. All rights reserved.
//

import UIKit
import RxCocoa

enum SearchRowType {
    case single
    case fromTo
}

struct Parameter {
    var title: String
    var options = [String]()
    var value: String?
    
    init(title: String, options: [String], value: String? = nil) {
        self.title = title
        self.options = options
        self.value = value
    }
}

struct SearchRow {
    var index: Int!
    var type = SearchRowType.single
    var params = [Parameter]()
    
    static func single(params: Parameter) -> SearchRow {
        return SearchRow(type: .single, params: [params])
    }
    
    static func fromTo(from: Parameter, to: Parameter) -> SearchRow {
        return SearchRow(type: .fromTo, params: [from, to])
    }
    
    init(type: SearchRowType, params: [Parameter]) {
        self.type = type
        self.params = params
    }
    
    init(){}
}
