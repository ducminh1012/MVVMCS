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
    
    var disposeBag = DisposeBag()
    var viewModel: SearchFromToSelectionCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fromLabel.text = "From"
        toLabel.text = "To"
        
        fromButton.rx.tap.bind {
            self.viewModel?.didSelectFromButton?()
            }.disposed(by: disposeBag)
        
        toButton.rx.tap.subscribe(onNext: { (_) in
            self.viewModel?.didSelectToButton?()
        }).disposed(by: disposeBag)
    }
    
    func configure(with viewModel: SearchFromToSelectionCellViewModel) {
        self.viewModel = viewModel
        
        viewModel.fromValue.bind(to: fromButton.rx.title()).disposed(by: disposeBag)
        viewModel.toValue.bind(to: toButton.rx.title()).disposed(by: disposeBag)
        
        viewModel.fromValue.bind { selected in
            self.fromButton.setTitleColor((selected == "All") ? AppTheme.defaultTintColor : AppTheme.selectedTintColor, for: .normal)
        }.disposed(by: disposeBag)
        
        viewModel.toValue.bind { selected in
            self.toButton.setTitleColor((selected == "All") ? AppTheme.defaultTintColor : AppTheme.selectedTintColor, for: .normal)
        }.disposed(by: disposeBag)
    }
}
