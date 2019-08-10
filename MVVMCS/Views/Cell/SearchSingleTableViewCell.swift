//
//  SearchSingleTableViewCell.swift
//  MVVMCS
//
//  Created by Duc Le on 8/5/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit

class SearchSingleTableViewCell: UITableViewCell {
    
    var title = ""
    var options = [String]()
    
    func setupLayout(title: String?, options: [Parameter]) {
        textLabel?.text = title
        detailTextLabel?.text = options.first?.value ?? "All"
        self.options = options.map({$0.title})
    }
}
