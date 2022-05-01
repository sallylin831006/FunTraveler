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
    var user: VideoUser
    var url: String
    var location: String
    var createdTime: String
    
    enum CodingKeys: String, CodingKey {
        case user, url, location
        case createdTime = "created_at"
       
    }
}

struct VideoUser: Codable {
    var id: Int
    var name: String
    var imageUrl: String
    var isFriend: Bool
    var isInvite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case imageUrl = "image_url"
        case isFriend = "is_friend"
        case isInvite = "is_invite"
    }
}
