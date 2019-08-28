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
import XCoordinator

class SearchViewModel {
    let router: AnyRouter<SearchRoute>
    
    var searchForm = SearchForm()
    
    var allSections = BehaviorRelay<[SearchSection]>(value: [])
    var makeSection = SearchSection(type: .makeModel, items: [])
    
    var handleSelectAtIndex: ((IndexPath) -> Void)?
    var didSelectMake: ((String) -> Void)?
    var didSelectModel: ((String) -> Void)?
    
    init(router: AnyRouter<SearchRoute>) {
        self.router = router
        
        let makes = VehicleSearchService.shared.allMakes
        
        makeSection = SearchSection.makeModel(items: [
            SearchRow.single(params: [makes])
        ])

        self.allSections.accept([makeSection])
        
        didSelectMake = { (make) in
            let models = VehicleSearchService.shared.models(for: make)!
            
            self.makeSection = SearchSection.makeModel(items: [
                SearchRow.single(params: [makes]),
                SearchRow.single(params: [models])
            ])
            
            if make == "All" {
                self.makeSection = SearchSection.makeModel(items: [
                    SearchRow.single(params: [makes])
                ])
            }
            
            self.searchForm.selectedMake.accept(make)
            self.searchForm.selectedModel.accept("All")
            self.allSections.accept([self.makeSection])
        }
        
        didSelectModel = { model in
            self.searchForm.selectedModel.accept(model)
            self.allSections.accept([self.makeSection])
        }
        
        handleSelectAtIndex = { indexPath in            
            switch indexPath.row {
            case 0:
                let options = self.makeSection.items[indexPath.row].params.first?.options.value ?? []
                let selected = self.searchForm.selectedMake.value
                self.router.trigger(.searchSingleSelection(options, selected, .make))
            case 1:
                let options = self.makeSection.items[indexPath.row].params.first?.options.value ?? []
                let selected = self.searchForm.selectedModel.value
                self.router.trigger(.searchSingleSelection(options, selected, .model))
            default: break
            }
        }
    }
}
