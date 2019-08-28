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
            switch indexPath.row {
            case 0:
                let cell = table.dequeueReusableCell(withIdentifier: SearchSingleSelectionCell.identifier) as! SearchSingleSelectionCell
                cell.title.accept("Make")
                cell.value.accept(self.viewModel.searchForm.selectedMake.value)
                return cell
            case 1:
                let cell = table.dequeueReusableCell(withIdentifier: SearchSingleSelectionCell.identifier) as! SearchSingleSelectionCell
                cell.title.accept("Model")
                cell.value.accept(self.viewModel.searchForm.selectedModel.value)
                return cell
            default:
                return UITableViewCell()                
            }
        
        })
        
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            self.viewModel.handleSelectAtIndex?(indexPath)
        }).disposed(by: disposeBag)
        
        viewModel.allSections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}
