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

class SearchDetailViewController: UIViewController, Storyboardable {
    weak var coordinator: SearchDetailCoordinator?
    var viewModel: SearchDetailViewModel!
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let data = Observable.just(viewModel.rowData.params.value[0].options)
        
        data.bind(to: tableView.rx.items(cellIdentifier: "SearchDetailSingleCell")) { (index, data, cell) in
            let a = self.viewModel.rowData.params.value[0].value
            cell.backgroundColor = (a == data) ? .green : .white
            cell.textLabel?.text = data
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            let selected = self.viewModel.rowData.params.value[0].options[indexPath.row]
            var old = self.viewModel.rowData.params.value
            old[0].value = selected
            self.viewModel.rowData.params.accept(old)
            self.viewModel.didUpdateTitle?(self.viewModel.rowData)
            self.coordinator?.goBackHome()
        }).disposed(by: disposeBag)

    }
}
