//
//  ExploreRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/17.
//

import Foundation

enum ExploreRequest: STRequest {
    
    case getExplore
    
    var headers: [String: String] {
        
        switch self {
            
        case .getExplore:
            
            return [:]
            
        }
    }
    
    var body: Data? {
        
        switch self {
            
        case .getExplore: return nil
            
        }
        
    }
    
    var method: String {
        
        switch self {
            
        case .getExplore : return STHTTPMethod.GET.rawValue
            
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .getExplore:
            return "/api/v1/home"
            
        }
        
    }
    
}
