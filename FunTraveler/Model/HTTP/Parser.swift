//
//  Parser.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import Foundation

struct SuccessParser<T: Codable>: Codable {
    
    let data: T
    
    let paging: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case data
        
        case paging = "next_paging"
    }
}

struct FailureParser: Codable {
    
    let errorMessage: String
}
