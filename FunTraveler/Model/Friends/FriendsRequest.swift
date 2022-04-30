//
//  FriendsRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/29.
//

import Foundation

enum FriendsRequest: STRequest {
    
    case postToInvite(token: String, userId: Int)
    
    case postToAccept(token: String, userId: Int, isAccept: Bool)
    
    case getInviteList(token: String)
    
    case getFriendList(token: String, userId: Int)
    
    var headers: [String: String] {
        
        switch self {
            
        case .postToInvite(let token, _),
                .postToAccept(let token, _, _),
                .getInviteList(let token),
                .getFriendList(let token, _):
            
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
        }
    }
    
    var body: Data? {
        
        switch self {
            
        case .postToInvite: return nil
            
        case .postToAccept(_, _, let isAccept):
            
            let body = [
                "accept": isAccept
            ]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        case .getInviteList, .getFriendList : return nil
        
        }
        
    }
    var method: String {
        
        switch self {
            
        case .postToInvite : return STHTTPMethod.POST.rawValue
            
        case .postToAccept : return STHTTPMethod.POST.rawValue
            
        case .getFriendList : return STHTTPMethod.GET.rawValue
            
        case .getInviteList : return STHTTPMethod.GET.rawValue
        
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .postToInvite(_, let userId):
            return "/api/v1/user/\(userId)/invite"
            
        case .postToAccept(_, let userId, _):
            return "/api/v1/user/\(userId)/reply"
            
        case .getFriendList(_, let userId):
            return "/api/v1/user/\(userId)/friends"
            
        case .getInviteList:
            return "/api/v1/user/invites"
            
        }
        
    }
}
