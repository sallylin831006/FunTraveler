//
//  DomainConstant.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import Foundation

struct DomainConstant { //可拆開在另一個檔案

    static let urlKey = "STBaseURL" //寫在info.plist
    static let urlMap = "MapBaseURL" //寫在info.plist
    // https://maps.googleapis.com/maps/api

    enum Domain {
        case googleMap
    }
}
