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
        let allMakes = Parameter(title: "Make", options: ["All", "Audi", "Benley", "BMW", "BMW-Alpina", "Cadillac"], value: "All")
        let allModels = Parameter(title: "Model", options: ["All", "Audi", "Benley", "BMW", "BMW-Alpina", "Cadillac"], value: "All")
        
        let yearFrom = Parameter(title: "Year", options: ["2019", "2018", "2017", "2016"], value: "2018")
        let yearTo = yearFrom
        
        let priceFrom = Parameter(title: "Price", options: ["CHF 1'000", "CHF 2'000", "CHF 3'000", "CHF 4'000", "CHF 5'000"], value: "CHF 3'000")
        let priceTo = priceFrom
        
        makeSection = SearchSection.makeModel(items: [
            SearchRow.single(params: [allMakes]),
            SearchRow.single(params: [allModels])
            ]
        )
        
        priceSection = SearchSection.price(items: [
            SearchRow.single(params: [yearFrom, yearTo]),
            SearchRow.single(params: [priceFrom, priceTo])
            ]
        )
        
        self.form = SearchForm(sections: [
            makeSection,
            priceSection
            ]
        )
    }
}
