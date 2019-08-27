//
//  SearchDetailViewController.swift
//  MVVMCS
//
//  Created by Duc Le on 8/2/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchDetailViewController: UIViewController, Storyboardable, BindableType {
    
    
    var viewModel: SearchDetailViewModel!
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        let data = viewModel.rowData.value.params[0].options

        data.bind(to: tableView.rx.items(cellIdentifier: "SearchDetailSingleCell")) { (index, data, cell) in
            let a = self.viewModel.rowData.value.params[0].value
            cell.backgroundColor = (a == data) ? .green : .white
            cell.textLabel?.text = data
            }.disposed(by: disposeBag)

        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            let selected = self.viewModel.rowData.value.params[0].options.value[indexPath.row]
            var old = self.viewModel.rowData.value.params
            old[0].value = selected

            var a = self.viewModel.rowData.value
            a.params = old
            self.viewModel.rowData.accept(a)
            
            self.viewModel.didSelectMake?(selected)
            self.viewModel.router.trigger(.back)
        }).disposed(by: disposeBag)
    }
}
