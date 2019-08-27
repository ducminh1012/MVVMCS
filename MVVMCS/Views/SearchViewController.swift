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
                let cell = table.dequeueReusableCell(withIdentifier: SearchMakeTableViewCell.identifier) as! SearchMakeTableViewCell
                cell.title.accept("Make")
                cell.value.accept(self.viewModel.form.selectedMake.value)
                return cell
            case 1:
                let cell = table.dequeueReusableCell(withIdentifier: SearchMakeTableViewCell.identifier) as! SearchMakeTableViewCell
                cell.title.accept("Model")
                cell.value.accept(self.viewModel.form.selectedModel.value)
                return cell
            default: return UITableViewCell()
                
            }
        
        })
        
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            switch indexPath.row {
            case 0:
                let row = self.viewModel.makeSection.items[indexPath.row]
                self.viewModel.router.trigger(.searchSingleSelection(row))
            case 1:
                let row = self.viewModel.makeSection.items[indexPath.row]
                self.viewModel.router.trigger(.searchSingleSelection(row))
            default: break
            }
        }).disposed(by: disposeBag)
        
        viewModel.allSections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}
