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
    let router: UnownedRouter<SearchRoute>
    
    var searchForm = SearchForm()
    
    var allSections = BehaviorRelay<[SearchSection]>(value: [])

    var handleSelectForm: ((SearchFormRowType) -> Void)?
    var didSelectMake: ((String) -> Void)?
    var didSelectModel: ((String) -> Void)?
    var didSelectFromPrice: ((String) -> Void)?
    var didSelectToPrice: ((String) -> Void)?
    var didPerformSearch: ((SearchForm) -> Void)?
    
    init(router: UnownedRouter<SearchRoute>) {
        self.router = router
        
        let makes = VehicleSearchService.shared.allMakes
        let fromPrices = VehicleSearchService.shared.fromPrices
        let toPrices = VehicleSearchService.shared.toPrices
        
        var makeSection = SearchSection.makeModel(items: [
            SearchRow.single(params: makes)
        ])
        
        let priceSection = SearchSection.price(items: [
            SearchRow.fromTo(from: fromPrices, to: toPrices)
        ])

        allSections.accept([makeSection, priceSection])
        
        didSelectMake = { (make) in
            let models = VehicleSearchService.shared.models(for: make)!
            
            makeSection = SearchSection.makeModel(items: [
                SearchRow.single(params: makes),
                SearchRow.single(params: models)
            ])
            
            if make == "All" {
                makeSection = SearchSection.makeModel(items: [
                    SearchRow.single(params: makes)
                ])
            }
            
            self.searchForm.selectedMake.accept(make)
            self.searchForm.selectedModel.accept("All")
            self.allSections.accept([makeSection, priceSection])
        }
        
        didSelectModel = { model in
            self.searchForm.selectedModel.accept(model)
            self.allSections.accept([makeSection, priceSection])
        }
        
        didSelectToPrice = { toPrice in
            self.searchForm.selectedToPrice.accept(toPrice)
            self.allSections.accept([makeSection, priceSection])
        }
        
        didSelectFromPrice = { fromPrice in
            self.searchForm.selectedFromPrice.accept(fromPrice)
            self.allSections.accept([makeSection, priceSection])
        }
        
        handleSelectForm = { formType in
            switch formType {
            case .make:
                let options = makeSection.items[0].params.first?.options ?? []
                let selected = self.searchForm.selectedMake.value
                self.router.trigger(.searchSingleSelection(options, selected, .make))
            case .model:
                let options = makeSection.items[1].params.first?.options ?? []
                let selected = self.searchForm.selectedModel.value
                self.router.trigger(.searchSingleSelection(options, selected, .model))
                
            case .fromPrice:
                let selected = self.searchForm.selectedFromPrice.value
                let fromPrices = priceSection.items[0].params.first?.options ?? []
                self.router.trigger(.searchSingleSelection(fromPrices, selected, .fromPrice))
            case .toPrice:
                let selected = self.searchForm.selectedToPrice.value
                let toPrices = priceSection.items[0].params[1].options
                self.router.trigger(.searchSingleSelection(toPrices, selected, .toPrice))
            }
            
        }
        
        didPerformSearch = { form in
            self.router.trigger(.searchResult)
        }
    }
    
    func singleCellViewModel(at index: Int) -> SearchSingleSelectionCellViewModel? {
        switch index {
        case 0:
            return SearchSingleSelectionCellViewModel(title: "Make", options: [], value: searchForm.selectedMake.value)
        case 1:
            return SearchSingleSelectionCellViewModel(title: "Model", options: [], value: searchForm.selectedModel.value)
        default:
            return nil
        }
    }
    
    func fromToCellViewModel(at index: Int, selectFrom: (() -> Void)?, selectTo: (() -> Void)?) -> SearchFromToSelectionCellViewModel? {
        switch index {
        case 0:
            let viewModel = SearchFromToSelectionCellViewModel(fromOptions: [], toOptions: [], fromValue: searchForm.selectedFromPrice.value, toValue: searchForm.selectedToPrice.value)
            viewModel.didSelectFromButton = selectFrom
            viewModel.didSelectToButton = selectTo
            return viewModel
        default:
            return nil
        }
    }
}
