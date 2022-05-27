//
//  CoEditRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/2.
//

import Foundation

enum CoEditRequest: STRequest {
    
    case addEditor(token: String, tripId: Int, editorId: Int)
    
    case removeEditor(token: String, tripId: Int, editorId: Int)
    
    var headers: [String: String] {
        
        switch self {
            
        case .addEditor(let token, _, _), .removeEditor(let token, _, _):
            
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
        }
    }
    
    var body: Data? {
        
        switch self {
            
        case .addEditor(_, _, let editorId), .removeEditor(_, _, let editorId):
            
            let body = [
                "editor_user_id": editorId
            ]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)

        }
        
    }
    var method: String {
        
        switch self {
            
        case .addEditor : return STHTTPMethod.POST.rawValue
            
        case .removeEditor : return STHTTPMethod.DELETE.rawValue

        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .addEditor(_, let tripId, _), .removeEditor(_, let tripId, _):
            return "/api/v1/trips/\(tripId)/editors"
            
        }
        
    }
}
