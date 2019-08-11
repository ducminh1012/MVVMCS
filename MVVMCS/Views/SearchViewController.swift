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
        let sections = Observable.just(self.viewModel.form.allSections)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SearchSection>(configureCell: { dataSource, table, indexPath, item in
            switch item.type {
            case .single:
                let cell = table.dequeueReusableCell(withIdentifier: SearchSingleTableViewCell.identifier) as! SearchSingleTableViewCell
                cell.setupLayout(param: dataSource[indexPath.section].items[indexPath.item].params.value.first!)
                return cell
            default: return UITableViewCell()
                
            }
        })
        
        sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.subscribe({ (event) in
            let indexPath = event.element!
            self.coordinator?.showDetail(index: indexPath, in: self.navigationController!, callback: { rowData in
                print("did select title \(rowData.title)")
                self.viewModel.form.allSections[0].items[0].params.accept(rowData.params.value)
//                var v = self.viewModel.form.allSections
//                v[indexPath.section].items[indexPath.item] = rowData
//                self.viewModel.form.allSections.accept(v)
            })
            
        }).disposed(by: disposeBag)

        viewModel.form.allSections.first?.items.first?.params.subscribe(onNext: { (params) in
            print("did update params \(params)")
//            self.viewModel.form.allSections[0].items[0].data.accept(params)
        }).disposed(by: disposeBag)
        
        viewModel.makeSection.items[0].params.asObservable().subscribe { (event) in
//            print(event.element)
            self.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.makeSection.items[1].params.asObservable().subscribe { (event) in
            print(event.element)
            self.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.priceSection.items[0].params.asObservable().subscribe { (event) in
            print(event.element)
            self.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        viewModel.priceSection.items[1].params.asObservable().subscribe { (event) in
            print(event.element)
            self.tableView.reloadData()
            }.disposed(by: disposeBag)
    }
}
