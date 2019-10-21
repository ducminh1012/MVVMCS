//
//  MainViewController.swift
//  MVVMCS
//
//  Created by Duc Le on 10/21/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, Storyboardable {
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .red
    }
}
