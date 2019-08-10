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
    var model: Model
    
    var form: SearchForm
    
    func performSearch(for query: String) -> Observable<[SearchResponse]> {
        let response = SearchResponse(title: "test", description: "desc")
        return Observable.just([response])
    }
    
    var didSelectItem: ((IndexPath) -> Void)?
    var didTapBack: (() -> Void)?
    
    func detailViewModel(at indexPath: IndexPath) -> SearchDetailViewModel {
        return SearchDetailViewModel(row: form.allSections.value[indexPath.section].items[indexPath.row])
    }
    
    init(model: Model) {
        self.model = model
        self.form = SearchForm(sections: [
            SearchSection(type: .makeModel, title: "Make", items: [
                SearchRow.single(title: "Make", data: [("test", ["tttt"], "1234")]),
                SearchRow.single(title: "Model", data: [("test", ["tttt"], "1234")])])
            ]
        )
        
        
    }
    
    func bindingData() {

    }
}
