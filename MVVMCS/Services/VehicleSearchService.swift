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
    
    let allMakes = Parameter(title: "Make", options: Array(masterData["vehicles"]!.keys).sorted(), value: "All")
    let fromPrices = Parameter(title: "From", options: Array(masterData["prices"]?["from"] ?? []), value: "All")
    let toPrices = Parameter(title: "To", options: Array(masterData["prices"]?["to"] ?? []), value: "All")
    
    func models(for selectedMake: String) -> Parameter? {
        guard let models = masterData["vehicles"]?[selectedMake] else { return nil }
        return Parameter(title: "Models", options: models, value: "All")
    }

}
