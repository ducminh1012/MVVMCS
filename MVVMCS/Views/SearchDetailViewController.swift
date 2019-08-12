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
        label.text = viewModel.rowData.params.value.first?.value
        label.backgroundColor = .red
        view.addSubview(label)
        
        let button = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        button.setTitle("back", for: .normal)
        button.backgroundColor = .green
        view.addSubview(button)
        
        
        let textfield = UITextField(frame: CGRect(x: 100, y: 300, width: 100, height: 40))
        textfield.backgroundColor = .red
        
        
        view.addSubview(textfield)
        
        button.rx.tap.subscribe { (event) in
            var a = self.viewModel.rowData.params.value
            a[0].value = textfield.text
            self.viewModel.rowData.params.accept(a)
            var b = self.viewModel.rowData
            b.params.accept(a)
            self.viewModel.didUpdateTitle?(b)
            self.coordinator?.goBackHome()
        }.disposed(by: disposeBag)
        
    
        self.viewModel.rowData.params.asObservable().subscribe(onNext: { (params) in
//            print("did update params \(params)")
        }).disposed(by: disposeBag)
    }
}
