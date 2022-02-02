//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Frannck Villanueva on 10/01/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    
    var rate: Double
    
    var rateString: String {
        return String(format: "%.2f", rate)
    }
}
