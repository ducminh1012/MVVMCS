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

class SearchViewModel {
    var form: SearchForm
    var makeSection: SearchSection!
    var priceSection: SearchSection!
    var disposeBag = DisposeBag()
    
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
        form = SearchForm()
        
        form.selectedMake.subscribe(onNext: { (make) in
            self.form.reloadData()
        }).disposed(by: disposeBag)
    }
}
