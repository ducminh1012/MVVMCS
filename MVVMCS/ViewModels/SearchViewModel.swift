//
//  SearchViewModel.swift
//  MVVMCS
//
//  Created by Duc Le on 7/31/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

struct SearchViewModel {
    var form: SearchForm
    var makeSection: SearchSection!
    var priceSection: SearchSection!
    
    func performSearch(for query: String) -> Observable<[SearchResponse]> {
        let response = SearchResponse(title: "test", description: "desc")
        return Observable.just([response])
    }
    
    var didSelectItem: ((IndexPath) -> Void)?
    var didTapBack: (() -> Void)?
    var didUpdateRow: ((IndexPath, SearchRow) -> Void)?
    
    func detailViewModel(at indexPath: IndexPath) -> SearchDetailViewModel {
        return SearchDetailViewModel(row: form.allSections.value[indexPath.section].items[indexPath.row])
    }

    init() {
        makeSection = SearchSection.makeModel(items: [
            SearchRow.single(title: "Make", options: [("Make", ["tttt"], "1234")]),
            SearchRow.single(title: "Model", options: [("Model", ["tttt"], "1234")])
            ]
        )
        
        priceSection = SearchSection.price(items: [
            SearchRow.single(title: "Year", options: [("From", ["tttt", "132131", "test data"], "1234"), ("To", ["tttt"], "1234")]),
            SearchRow.single(title: "Price", options: [("From", ["tttt"], "1234"), ("To", ["tttt"], "1234")])
            ]
        )
        
        self.form = SearchForm(sections: [
            makeSection,
            priceSection
            ]
        )
    }
}
