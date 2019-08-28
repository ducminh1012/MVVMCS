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
    var priceSection = SearchSection(type: .price, title: "Price section", items: [])
    
    var handleSelectForm: ((SearchFormRowType) -> Void)?
    var didSelectMake: ((String) -> Void)?
    var didSelectModel: ((String) -> Void)?
    var didSelectFromPrice: ((String) -> Void)?
    var didSelectToPrice: ((String) -> Void)?
    
    init(router: AnyRouter<SearchRoute>) {
        self.router = router
        
        let makes = VehicleSearchService.shared.allMakes
        let prices = VehicleSearchService.shared.fromPrices
        
        makeSection = SearchSection.makeModel(items: [
            SearchRow.single(params: makes)
        ])
        
        priceSection = SearchSection.price(items: [
            SearchRow.fromTo(from: prices, to: prices)
        ])

        self.allSections.accept([makeSection, priceSection])
        
        didSelectMake = { (make) in
            let models = VehicleSearchService.shared.models(for: make)!
            
            self.makeSection = SearchSection.makeModel(items: [
                SearchRow.single(params: makes),
                SearchRow.single(params: models)
            ])
            
            if make == "All" {
                self.makeSection = SearchSection.makeModel(items: [
                    SearchRow.single(params: makes)
                ])
            }
            
            self.searchForm.selectedMake.accept(make)
            self.searchForm.selectedModel.accept("All")
            self.allSections.accept([self.makeSection, self.priceSection])
        }
        
        didSelectModel = { model in
            self.searchForm.selectedModel.accept(model)
            self.allSections.accept([self.makeSection, self.priceSection])
        }
        
        didSelectToPrice = { toPrice in
            self.searchForm.selectedToPrice.accept(toPrice)
            self.allSections.accept([self.makeSection, self.priceSection])
        }
        
        didSelectFromPrice = { fromPrice in
            self.searchForm.selectedFromPrice.accept(fromPrice)
            self.allSections.accept([self.makeSection, self.priceSection])
        }
        
        handleSelectForm = { formType in
            switch formType {
            case .make:
                let options = self.makeSection.items[0].params.first?.options ?? []
                let selected = self.searchForm.selectedMake.value
                self.router.trigger(.searchSingleSelection(options, selected, .make))
            case .model:
                let options = self.makeSection.items[1].params.first?.options ?? []
                let selected = self.searchForm.selectedModel.value
                self.router.trigger(.searchSingleSelection(options, selected, .model))
                
            case .fromPrice:
                let selected = self.searchForm.selectedFromPrice.value
                let fromPrices = self.priceSection.items[0].params.first?.options ?? []
                self.router.trigger(.searchSingleSelection(fromPrices, selected, .fromPrice))
            case .toPrice:
                let selected = self.searchForm.selectedToPrice.value
                let toPrices = self.priceSection.items[0].params[1].options
                self.router.trigger(.searchSingleSelection(toPrices, selected, .toPrice))
            }
            
        }
    }
}
