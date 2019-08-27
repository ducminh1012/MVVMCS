//
//  SearchSingleSelectionViewController.swift
//  MVVMCS
//
//  Created by Duc Le on 8/2/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchSingleSelectionViewController: UIViewController, Storyboardable, BindableType {
    
    var viewModel: SearchSingleSelectionViewModel!
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    func bindViewModel() {

        viewModel.options.bind(to: tableView.rx.items(cellIdentifier: "SearchDetailSingleCell")) { (index, data, cell) in
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
            }
            
            self.viewModel.router.trigger(.back)
        }).disposed(by: disposeBag)
    }
}
