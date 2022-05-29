//
//  ReactionObject.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/26.
//

import Foundation

struct Comments: Codable {
    var data: [Comment]
}

struct SingleCmment: Codable {
    var data: Comment
}

struct Comment: Codable {
    var user: User
    var id: Int
    var content: String
    var commentByMe: Bool
    var duration: Int
    
    enum CodingKeys: String, CodingKey {
        case user, id, content, duration
        case commentByMe = "comment_by_me"
    }
}
