//
//  VideoObject.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/24.
//

import Foundation

struct Videos: Codable {
    var data: [Video]
}

struct Video: Codable {
    var user: User
    var url: String
    var location: String
    var createdTime: String
    
    enum CodingKeys: String, CodingKey {
        case user, url, location
        case createdTime = "created_at"
       
    }
}
