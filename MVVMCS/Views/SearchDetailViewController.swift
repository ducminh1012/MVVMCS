//
//  SearchDetailViewController.swift
//  MVVMCS
//
//  Created by Duc Le on 8/2/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchDetailViewController: UIViewController, Storyboardable {
    weak var coordinator: SearchDetailCoordinator?
    var viewModel: SearchDetailViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 50, height: 50)))
//        label.text = viewModel.rowData.value.data.first?.value
        label.backgroundColor = .red
        view.addSubview(label)
        
        let button = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        button.setTitle("back", for: .normal)
        button.backgroundColor = .green
        view.addSubview(button)
        
        
        let textfield = UITextField(frame: CGRect(x: 100, y: 300, width: 100, height: 40))
        textfield.backgroundColor = .red
        
        
        view.addSubview(textfield)
        
        self.viewModel.rowData.subscribe(onNext: { (data) in
            textfield.text = data.data.value[0].value
            label.text = data.data.value[0].value
        }).disposed(by: disposeBag)
        
        button.rx.tap.subscribe { (event) in
            var a = self.viewModel.rowData.value
            a.data.v[0].value = textfield.text
            
            self.viewModel.rowData.accept(a)
            self.viewModel.didUpdateTitle?(a)
            self.coordinator?.goBackHome()
        }.disposed(by: disposeBag)
    
    }
}
