//
//  VideoRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/24.
//

import Foundation

enum VideoRequest: STRequest {
    
    case getVideo(token: String)
    
    case postVideoLike(token: String, videoId: Int, type: Int)
    
    var headers: [String: String] {
        
        switch self {
            
        case .getVideo(let token), .postVideoLike(let token, _, _):
            
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
            
        }
    }
    
    var body: Data? {
        
        switch self {
            
        case .getVideo: return nil
            
        case .postVideoLike(_, _, let type):
            
            let body = [
                "type": type,
            ]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
            
        }
    }
    var method: String {
        
        switch self {
            
        case .getVideo : return STHTTPMethod.GET.rawValue
        case .postVideoLike : return STHTTPMethod.POST.rawValue

        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .getVideo:
            return "/api/v1/videos"
        case .postVideoLike(_, let videoId, _):
            return "/api/v1/videos/\(videoId)/rating"
        }
        
    }
}
