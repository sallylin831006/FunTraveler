//
//  UserObject.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import Foundation

struct Token: Codable {
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}

struct RegisterError: Codable {
    var errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "error_message"
    }
}
