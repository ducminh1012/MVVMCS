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
    var parameter: Parameter!
    
    func setupLayout(param: Parameter) {
        self.parameter = param
        textLabel?.text = param.title
        detailTextLabel?.text = param.value
    }
}
