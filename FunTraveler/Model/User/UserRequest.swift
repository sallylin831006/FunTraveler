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
            
        }
    }
    var method: String {
        
        switch self {
            
        case .register : return STHTTPMethod.POST.rawValue
            
        case .login : return STHTTPMethod.POST.rawValue
            
        case .appleLogin : return STHTTPMethod.POST.rawValue

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
        }
        
    }
}
