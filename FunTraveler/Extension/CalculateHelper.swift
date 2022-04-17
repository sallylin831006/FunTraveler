//
//  CalculateHelper.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/16.
//

import Foundation

extension Double {
    func rounding(toDecimal decimal: Int) -> Double {
        let numberOfDigits = pow(10.0, Double(decimal))
        return (self * numberOfDigits).rounded(.toNearestOrAwayFromZero) / numberOfDigits
    }
}
