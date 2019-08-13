//
//  VehicleSearchService.swift
//  MVVMCS
//
//  Created by Duc Le on 8/13/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import Foundation

class VehicleSearchService {
    static let shared = VehicleSearchService()
    
    let allMakes = Parameter(title: "Make", options: ["All", "Audi", "Benley", "BMW", "BMW-Alpina", "Cadillac"], value: "All")
    let allModels = Parameter(title: "Model", options: ["All", "A1", "A2", "A3", "A4", "A5"], value: "All")
    
    func models(for selectedMake: Parameter) {
        
    }
}
