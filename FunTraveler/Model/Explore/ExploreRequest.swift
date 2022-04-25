//
//  ExploreRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/17.
//

import Foundation

enum ExploreRequest: STRequest {
    
    case getExplore
    
    case searchTrips(word: String)
    
    var headers: [String: String] {
        
        switch self {
            
        case .getExplore, .searchTrips:
            
            return [
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
            
        }
    }
    
    var body: Data? {
        
        switch self {
            
        case .getExplore: return nil
            
        case .searchTrips(let word):
            
            let body = [
                "word": word
            ]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        }
        
    }
    
    var method: String {
        
        switch self {
            
        case .getExplore : return STHTTPMethod.GET.rawValue
        case .searchTrips : return STHTTPMethod.POST.rawValue
            
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .getExplore:
            return "/api/v1/home"
        case .searchTrips:
            return "/api/v1/search"
            
        }
        
    }
    
}
