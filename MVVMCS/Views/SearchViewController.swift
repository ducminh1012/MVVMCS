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
                cell.setupLayout(title: item.title, options: item.data)
                return cell
            default: return UITableViewCell()
                
            }
        })
        
        self.viewModel.form.allSections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.subscribe({ (event) in
            let indexPath = event.element!
            self.coordinator?.showDetail(index: indexPath, in: self.navigationController!, callback: { rowData in
                print("did select title \(rowData.title)")
                
                var v = self.viewModel.form.allSections.value
                v[indexPath.section].items[indexPath.item] = rowData
                self.viewModel.form.allSections.accept(v)
            })
        }).disposed(by: disposeBag)

    }
}
