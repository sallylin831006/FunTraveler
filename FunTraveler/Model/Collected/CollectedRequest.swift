//
//  CollectedRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/20.
//

import Foundation

enum CollectedRequest: STRequest {
    
    case collectedTrip(token: String, isCollected: Bool, tripId: Int)
    
    var headers: [String: String] {
        
        switch self {
            
        case .collectedTrip(let token, _, _):
            
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
            
        }
    }
    
    var body: Data? {
        
        switch self {
 
        case .collectedTrip(_, let isCollected, let tripId):

            let body = [
                "isCollected": isCollected,
                "tripId": tripId
            ] as [String : Any]

            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        }
    }
    var method: String {
        
        switch self {
            
        case .collectedTrip : return STHTTPMethod.POST.rawValue
            
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .collectedTrip(_, let isCollected, let tripId):
            return "/api/v1/trips/\(tripId)" //要改
            
        }
        
    }
}
