//
//  SearchSingleTableViewCell.swift
//  MVVMCS
//
//  Created by Duc Le on 8/5/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import RxCocoa
import RxSwift

class SearchSingleSelectionCell: UITableViewCell {
    
    var title = BehaviorRelay(value: "")
    var value = BehaviorRelay(value: "All")
    var options = BehaviorRelay(value: [String]())
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.bind(to: textLabel!.rx.text).disposed(by: disposeBag)
        value.bind(to: detailTextLabel!.rx.text).disposed(by: disposeBag)        
    }
}
