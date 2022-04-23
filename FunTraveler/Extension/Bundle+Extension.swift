//
//  Bundle+Extension.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import Foundation

extension Bundle {
    // swiftlint:disable force_cast
    static func STValueForString(key: String) -> String {
        
        return Bundle.main.infoDictionary![key] as! String
    }

    static func STValueForInt32(key: String) -> Int32 {

        return Bundle.main.infoDictionary![key] as! Int32
    }
    // swiftlint:enable force_cast
}
