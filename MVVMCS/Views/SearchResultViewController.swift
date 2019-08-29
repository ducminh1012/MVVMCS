//
//  SearchResultViewController.swift
//  MVVMCS
//
//  Created by Duc Le on 8/29/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit
import RxCocoa

class SearchResultViewController: UIViewController, Storyboardable, BindableType {
    
    var viewModel: SearchResultViewModel!

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        
    }
}
