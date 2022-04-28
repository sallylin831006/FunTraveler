//
//  UserRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import Foundation
import SwiftUI

enum UserRequest: STRequest {
    
    case register(email: String, password: String, name: String)
    
    case login(email: String, password: String)
    
    case appleLogin(appleToken: String)
    
    case getProfile(token: String, userId: Int)
    
    case updateProfile(token: String, name: String, image: String)
    
    case deleteUser(token: String)
    
    var headers: [String: String] {
        
        switch self {
            
        case .register, .login:
            
            return [
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
            
        case .appleLogin(let appleToken):
            
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(appleToken)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
            
        case .getProfile(let token, _), .updateProfile(let token, _, _), .deleteUser(let token):
            
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
            
        case .getProfile, .deleteUser: return nil
            
        case .updateProfile(_, let name, let image):
            
            let body = [
                "name": name,
                "image": image
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
            
        case .updateProfile : return STHTTPMethod.PATCH.rawValue

        case .deleteUser : return STHTTPMethod.DELETE.rawValue

        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .register:
            return "/api/v1/auth/email/register"
            
        case .login, .appleLogin:
            return "/api/v1/auth/email/login"
            
        case .updateProfile, .deleteUser:
            return "/api/v1/user"
        case .getProfile(_, let userId):
            return "/api/v1/user/\(userId)"
            
        }
        
    }
}
