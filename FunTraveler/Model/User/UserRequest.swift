//
//  UserRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import Foundation

enum UserRequest: STRequest {
    
    case register(email: String, password: String, name: String)
    
    case login(email: String, password: String)
    
    case appleLogin(appleToken: String)
    
    case getProfile(token: String, userId: Int)
    
    case getProfileTrips(token: String, userId: Int)
    
    case updateProfile(token: String, name: String, image: String)
    
    case deleteUser(token: String)
    
    case blockUser(token: String, userId: Int)
    
    case unBlockUser(token: String, userId: Int)
    
    case getBlockList(token: String)
    
    case postToSearchUser(token: String, text: String)
    
    var headers: [String: String] {
        
        switch self {
            
        case .register, .login, .appleLogin:
            
            return [
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
            
        case .getProfile(let token, _), .updateProfile(let token, _, _), .getProfileTrips(let token, _),
                .deleteUser(let token),
                .blockUser(let token, _),
                .unBlockUser(let token, _),
                .getBlockList(let token),
                .postToSearchUser(let token, _):
            
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
        }
    }
    
    var body: Data? {
        
        switch self {
            
        case .register(let email, let password, let name):
            
            let body = [
                "email": email,
                "password": password,
                "name": name
            ]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        case .login(let email, let password):
            
            let body = [
                "email": email,
                "password": password
            ]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        case .appleLogin(let appleToken):
            
            let body = [
                "token": appleToken
            ]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        case .getProfile, .deleteUser, .getProfileTrips, .blockUser, .unBlockUser, .getBlockList: return nil
            
        case .updateProfile(_, let name, let image):
            
            let body = [
                "name": name,
                "image": image
            ]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        case .postToSearchUser(_, let text):
            
            let body = [
                "name": text
            ]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        }
    }
    var method: String {
        
        switch self {
            
        case .register : return STHTTPMethod.POST.rawValue
            
        case .login : return STHTTPMethod.POST.rawValue
            
        case .appleLogin : return STHTTPMethod.POST.rawValue
            
        case .getProfile : return STHTTPMethod.GET.rawValue
            
        case .getProfileTrips : return STHTTPMethod.GET.rawValue
            
        case .updateProfile : return STHTTPMethod.PATCH.rawValue
            
        case .deleteUser : return STHTTPMethod.DELETE.rawValue
            
        case .blockUser : return STHTTPMethod.POST.rawValue
            
        case .unBlockUser : return STHTTPMethod.DELETE.rawValue
            
        case .getBlockList : return STHTTPMethod.GET.rawValue
            
        case .postToSearchUser : return STHTTPMethod.POST.rawValue
            
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .register:
            return "/api/v1/auth/email/register"
            
        case .login:
            return "/api/v1/auth/email/login"
        case .appleLogin:
            return "/api/v1/auth/apple/login"
            
        case .updateProfile, .deleteUser:
            return "/api/v1/user"
        case .getProfile(_, let userId):
            return "/api/v1/user/\(userId)"
            
        case .getProfileTrips(_, let userId):
            return "/api/v1/user/\(userId)/trips"
            
        case .blockUser(_, let userId), .unBlockUser(_, let userId):
            return "/api/v1/user/\(userId)/block"
            
        case .getBlockList:
            return "/api/v1/user/blocks"
            
        case .postToSearchUser:
            return "/api/v1/user/search"
            
        }
        
    }
}
