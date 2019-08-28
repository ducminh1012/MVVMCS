//
//  SearchFromToSelectionCell.swift
//  MVVMCS
//
//  Created by Duc Le on 8/28/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import RxSwift
import RxCocoa

class SearchFromToSelectionCell: UITableViewCell {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    
    var fromValue = BehaviorRelay(value: "All")
    var toValue = BehaviorRelay(value: "All")
    
    var fromOptions = BehaviorRelay(value: [String]())
    var toOptions = BehaviorRelay(value: [String]())
    var disposeBag = DisposeBag()
    
    var didSelectFromButton: (() -> Void)?
    var didSelectToButton: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fromLabel.text = "From"
        toLabel.text = "To"
        
        fromValue.bind(to: fromButton.rx.title()).disposed(by: disposeBag)
        toValue.bind(to: toButton.rx.title()).disposed(by: disposeBag)
        
        fromButton.rx.tap.subscribe(onNext: { (_) in
            self.didSelectFromButton?()
        }).disposed(by: disposeBag)
        
        toButton.rx.tap.subscribe(onNext: { (_) in
            self.didSelectToButton?()
        }).disposed(by: disposeBag)
    }
}
