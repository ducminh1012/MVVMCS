//
//  MasterData.swift
//  MVVMCS
//
//  Created by Duc Le on 8/14/19.
//  Copyright © 2019 Duc Le. All rights reserved.
//

import Foundation

let masterData: [String: [String: [String]]] = [
    "vehicles": [
        "All": [],
        "Audi": [
            "All", "A1", "A2", "A3", "A4", "A5"
        ],
        
        "BMW": [
            "All", "1 Series", "2 Series", "M-Series", "X-Series", "Z-Series"
        ],
        
        "Benley": [
            "All", "ARNAGE", "AZURE", "EIGHT", "S2", "TURBO"
        ],
        
        "Chevrolet": [
            "All", "ALERO", "ASTRO", "AVEO", "CAMARO", "CAPITOL"
        ],
        
        "Cadillac": [
            "All", "CT6", "DEVILLE", "SRX"
        ]
    ],
    "prices": ["from": ["500", "600", "700", "1'000"], "to": ["500", "600", "700", "1'000"]]
]
