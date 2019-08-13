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
            SearchRow.single(params: [("Make", ["All", "Audi", "Benley", "BMW", "BMW-Alpina", "Cadillac"], "All")]),
            SearchRow.single(params: [("Model", ["tttt"], "All")])
            ]
        )
        
        priceSection = SearchSection.price(items: [
            SearchRow.single(params: [("Year From", ["2019", "2018", "2017", "2016"], "2018"), ("To", ["tttt"], "1234")]),
            SearchRow.single(params: [("Price From", ["CHF 1'000", "CHF 2'000", "CHF 3'000", "CHF 4'000", "CHF 5'000"], "CHF 3'000"), ("To", ["CHF 1'000", "CHF 2'000", "CHF 3'000", "CHF 4'000", "CHF 5'000"], "CHF 5'000" )])
            ]
        )
        
        self.form = SearchForm(sections: [
            makeSection,
            priceSection
            ]
        )
    }
}
