//
//  UserObject.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import Foundation

struct Token: Codable {
    var token: String
    var refreshToken: String
    var userId: Int
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case refreshToken = "refresh_token"
        case userId = "user_id"
    }
}

struct RegisterError: Codable {
    var errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "error_message"
    }
}

// MARK: - GET USERS PROFILE

struct UserProfile: Codable {
    var data: Profile
}

struct Profile: Codable {
    var id: Int
    var name: String
    var imageUrl: String
    var isFriend: Bool
    var isInvite: Bool
    var numberOfFriends: Int
    var numberOfTrips: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case imageUrl = "image_url"
        case isFriend = "is_friend"
        case isInvite = "is_invite"
        case numberOfFriends = "friends_count"
        case numberOfTrips = "trip_count"
        
    }
}
