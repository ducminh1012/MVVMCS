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

class SearchViewController: UIViewController, Storyboardable {
    weak var coordinator: SearchCoordinator?
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let disposeBag = DisposeBag()
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
}

//MARK: - Private
extension SearchViewController {
    
    fileprivate func setup() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SearchSection>(configureCell: { dataSource, table, indexPath, item in
            switch item.type {
            case .single:
                let cell = table.dequeueReusableCell(withIdentifier: SearchSingleTableViewCell.identifier) as! SearchSingleTableViewCell
                cell.setupLayout(param: dataSource[indexPath.section].items[indexPath.item].params.value.first!)
                return cell
            default: return UITableViewCell()
                
            }
        })
        
        self.viewModel.form.allSections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.viewModel.form.selectedModel.asObservable().subscribe(onNext: { (value) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        self.viewModel.form.selectedMake.asObservable().subscribe(onNext: { (value) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe({ (event) in
            
            let indexPath = event.element!
            self.coordinator?.showDetail(index: indexPath, in: self.navigationController!, callback: { rowData in
                var allSections = self.viewModel.form.allSections.value
                allSections[indexPath.section].items[indexPath.row] = rowData
                self.viewModel.form.allSections.accept(allSections)
                
                switch indexPath.section {
                case 0:
                    if indexPath.row == 0 {
                        self.viewModel.form.selectedMake.accept(rowData.params.value[0].value!)
                    } else {
                        
                        self.viewModel.form.selectedModel.accept(rowData.params.value[0].value!)
                    }
                default: break
                }
               
                
            })
            
        }).disposed(by: disposeBag)

    }
}
