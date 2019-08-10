//
//  SearchSection.swift
//  AutoScout24
//
//  Created by Duc Le on 4/1/19.
//  Copyright © 2019 Scout24.ch. All rights reserved.
//

import UIKit
import RxDataSources

enum SearchSectionType {
    case makeModel
    case year
}

struct SearchSection {
    var type = SearchSectionType.makeModel
    var title = ""
    var items = [SearchRow]()
    
    static func makeModel(items: [SearchRow]) -> SearchSection {
        return SearchSection(type: .makeModel, items: items)
    }
    
    static func year(items: [SearchRow]) -> SearchSection {
        return SearchSection(type: .year, items: items)
    }
}

extension SearchSection: SectionModelType {
    typealias Item = SearchRow
    
    init(original: SearchSection, items: [SearchRow]) {
        self = original
        self.items = items
    }
    
    init(type: SearchSectionType, items: [SearchRow]) {
        self.items = items
        self.type = type
    }
}
