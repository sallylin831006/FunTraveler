//
//  CollectedRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/20.
//

import Foundation

enum CollectedRequest: STRequest {
    
    case postCollected(token: String, isCollected: Bool, tripId: Int)
    
    case getCollected(token: String)
    
    var headers: [String: String] {
        
        switch self {
            
        case .postCollected(let token, _, _), .getCollected(let token):
            
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
            
        }
    }
    
    var body: Data? {
        
        switch self {
 
        case .postCollected(_, let isCollected, let tripId):

            let body = [
                "trip_id": tripId,
                "is_collected": isCollected
            ] as [String: Any]

            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        case .getCollected: return nil

        }
    }
    var method: String {
        
        switch self {
            
        case .postCollected : return STHTTPMethod.POST.rawValue
            
        case .getCollected : return STHTTPMethod.GET.rawValue
            
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .postCollected:
            return "/api/v1/collections"
            
        case .getCollected:
            return "/api/v1/collections"
            
        }
        
    }
}
