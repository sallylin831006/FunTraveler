//
//  VideoRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/24.
//

import Foundation

enum VideoRequest: STRequest {
    
    case getVideo
    
    var headers: [String: String] {
        
        switch self {
            
        case .getVideo:
            
            return [
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
            
        }
    }
    
    var body: Data? {
        
        switch self {
            
        case .getVideo: return nil
            
        }
    }
    var method: String {
        
        switch self {
            
        case .getVideo : return STHTTPMethod.GET.rawValue
            
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .getVideo:
            return "/api/v1/videos"
            
        }
        
    }
}