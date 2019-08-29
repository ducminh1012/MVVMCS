//
//  ViewController.swift
//  MVVMCS
//
//  Created by Duc Le on 7/30/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import XCoordinator

class SearchViewController: UIViewController, Storyboardable, BindableType {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let disposeBag = DisposeBag()
    var viewModel: SearchViewModel!
    
    func bindViewModel() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SearchSection>(configureCell: { dataSource, table, indexPath, item in
            switch indexPath.section {
            case 0:
                guard let cell = table.dequeueReusableCell(withIdentifier: SearchSingleSelectionCell.identifier) as? SearchSingleSelectionCell,
                let viewModel = self.viewModel.singleCellViewModel(at: indexPath.row) else { return UITableViewCell() }

                cell.configure(with: viewModel)
                return cell

            case 1:
                guard let cell = table.dequeueReusableCell(withIdentifier: SearchFromToSelectionCell.identifier) as? SearchFromToSelectionCell else { return UITableViewCell() }
                guard let viewModel = self.viewModel.fromToCellViewModel(at: indexPath.row, selectFrom: {
                    self.viewModel.handleSelectForm?(.fromPrice)
                }, selectTo: {
                    self.viewModel.handleSelectForm?(.toPrice)
                }) else { return UITableViewCell() }
                
                cell.configure(with: viewModel)
                return cell
            default:
                return UITableViewCell()
            }
        
        })
        
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            guard indexPath.section == 0 else { return }
            self.viewModel.handleSelectForm?(indexPath.row == 0 ? .make : .model)
        }).disposed(by: disposeBag)
        
        viewModel.allSections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}
