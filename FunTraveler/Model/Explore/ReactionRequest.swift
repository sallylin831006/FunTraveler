//
//  Reaction.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/26.
//

import Foundation

enum ReactionRequest: STRequest {
    
    case postComment(token: String, content: String, tripId: Int)
    
    case getComment(tripId: Int)
    
    var headers: [String: String] {
        
        switch self {
            
        case .postComment(let token, _, _):
            
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
            
        case .getComment:
            
            return [
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
        }
    }
    
    var body: Data? {
        
        switch self {
            
        case .postComment(_, let content, _):
            let body = [
                "content": content
            ]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        case .getComment: return nil
            
        }
        
    }
    
    var method: String {
        
        switch self {
            
        case .postComment : return STHTTPMethod.POST.rawValue
        case .getComment : return STHTTPMethod.GET.rawValue
            
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .postComment(_, _, let tripId):
            return "/api/v1/trips/\(tripId)/comments"
        case .getComment(let tripId):
            return "/api/v1/trips/\(tripId)/comments"
            
        }
        
    }
    
}
