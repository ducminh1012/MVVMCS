//
//  SearchFromToSelectionViewController.swift
//  MVVMCS
//
//  Created by Duc Le on 8/28/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchFromToSelectionViewController: UIViewController, Storyboardable, BindableType {
    var viewModel: SearchSingleSelectionViewModel!
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    func bindViewModel() {
        
        viewModel.options.bind(to: tableView.rx.items(cellIdentifier: SearchSingleSelectionCell.identifier)) { (index, data, cell) in
            let selected = self.viewModel.selectedValue.value
            cell.backgroundColor = (selected == data) ? .green : .white
            cell.textLabel?.text = data
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            let selected = self.viewModel.options.value[indexPath.row]
            
            switch self.viewModel.type {
            case .make:
                self.viewModel.didSelectMake?(selected)
            case .model:
                self.viewModel.didSelectModel?(selected)
            case .fromPrice:
                self.viewModel.didSelectFromPrice?(selected)
            case .toPrice:
                self.viewModel.didSelectToPrice?(selected)
            }
        }).disposed(by: disposeBag)
    }
}
