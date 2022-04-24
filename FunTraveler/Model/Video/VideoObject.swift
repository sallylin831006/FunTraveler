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
//    var user: User
    var url: String
}

// struct User: Codable {
//    var id:  Int
//    var name: String
//    var userImage: String
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case userImage = "image_url"
//    }
// }
