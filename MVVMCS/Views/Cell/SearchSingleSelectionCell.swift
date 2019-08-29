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
    
    var viewModel: SearchSingleSelectionCellViewModel?
    var disposeBag = DisposeBag()
    
    func configure(with viewModel: SearchSingleSelectionCellViewModel) {
        self.viewModel = viewModel
        
        viewModel.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.value.bind(to: valueButton!.rx.title()).disposed(by: disposeBag)
        
        viewModel.value.bind { selected in
            self.valueButton.setTitleColor((selected == "All") ? .darkText : .blue, for: .normal)
        }.disposed(by: disposeBag)
    }
}
