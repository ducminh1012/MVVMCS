//
//  VehicleSearchService.swift
//  MVVMCS
//
//  Created by Duc Le on 8/13/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import Foundation
import SwiftyJSON

class VehicleSearchService {
    static let shared = VehicleSearchService()
    
    let allMakes = Parameter(title: "Make", options: Array(masterData.keys).sorted(), value: "All")
    
    func models(for selectedMake: String) -> Parameter? {
        guard let models = masterData[selectedMake] else { return nil }
        return Parameter(title: "Models", options: models, value: "All")
    }

}
