//
//  Reaction.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/26.
//

import Foundation

enum ReactionRequest: STRequest {
    
    case postComment(token: String, content: String, tripId: Int)
    
    case deleteComment(token: String, commentId: Int, tripId: Int)

    case getComment(token: String, tripId: Int)
    
    case postLiked(token: String, tripId: Int)

    case deleteUnLiked(token: String, tripId: Int)
    
    case getLiked(token: String, tripId: Int)

    var headers: [String: String] {
        
        switch self {
            
        case .postComment(let token, _, _), .deleteComment(let token, _, _),
                .postLiked(let token, _), .deleteUnLiked(let token, _) ,
                .getLiked(let token, _), .getComment(let token, _):
            
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
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
            
        case .getComment, .deleteComment, .postLiked, .deleteUnLiked, .getLiked: return nil
            
        }
        
    }
    
    var method: String {
        
        switch self {
            
        case .postComment : return STHTTPMethod.POST.rawValue
        case .deleteComment : return STHTTPMethod.DELETE.rawValue
        case .getComment : return STHTTPMethod.GET.rawValue
        case .postLiked : return STHTTPMethod.POST.rawValue
        case .deleteUnLiked : return STHTTPMethod.DELETE.rawValue
        case .getLiked : return STHTTPMethod.DELETE.rawValue

        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .postComment(_, _, let tripId):
            return "/api/v1/trips/\(tripId)/comments"
            
        case .deleteComment(_, let commentId, let tripId):
            return "/api/v1/trips/\(tripId)/comments/\(commentId)"
            
        case .getComment(_, let tripId):
            return "/api/v1/trips/\(tripId)/comments"
            
        case .postLiked(_, let tripId):
            return "/api/v1/trips/\(tripId)/likes"
            
        case .deleteUnLiked(_, let tripId):
            return "/api/v1/trips/\(tripId)/likes"
            
        case .getLiked(_, let tripId):
            return "/api/v1/trips/\(tripId)/likes"
            
        }
        
    }
    
}
