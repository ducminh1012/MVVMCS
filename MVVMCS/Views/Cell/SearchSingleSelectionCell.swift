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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueButton: UIButton!
    var title = BehaviorRelay(value: "")
    var value = BehaviorRelay(value: "All")
    var options = BehaviorRelay(value: [String]())
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        value.bind(to: valueButton!.rx.title()).disposed(by: disposeBag)
    }
}
