//
//  Form.swift
//  MVVMCS
//
//  Created by Duc Le on 8/23/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import RxSwift
import RxCocoa

class Form: NSObject {
    var selectedMake = BehaviorRelay<String>(value: "All")
    var selectedModel = BehaviorRelay<String>(value: "All")
}
