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
    var isCollected: Bool
    var isLiked: Bool
    var likeCount: Int
    var commentCount: Int
    var publishedDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, days, user, editors
        case isCollected = "is_collected"
        case likeCount = "likes_count"
        case commentCount = "comments_count"
        case isLiked = "is_liked"
        case publishedDate = "published_at"
    }
}

struct Users: Codable {
    var data: User
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
