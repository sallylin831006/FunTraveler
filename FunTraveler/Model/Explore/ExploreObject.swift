//
//  ExploreObject.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/17.
//

import Foundation

struct Explores: Codable {
    var data: [Explore]
}

struct Explore: Codable {
    var id: Int
    var title: String
    var days: Int
    var user: User
    var editors: [User]
}

struct User: Codable {
    var id: Int
    var name: String
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case imageUrl = "image_url"
    }
}
