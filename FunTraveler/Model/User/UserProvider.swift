//
//  UserProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import Foundation
import UIKit

// typealias RegisterHanlder = (Result<String>) -> Void
typealias RegisterErrorHanlder = (Result<RegisterError>) -> Void

typealias LoginHanlder = (Result<Token>) -> Void

typealias ErrorHanlder = (Result<ClientError>) -> Void

enum FunTravelerSignInError: Error {
    
    case noToken
}

class UserProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - POST TO Register
    func postToRegister(email: String,
                        password: String,
                        name: String, completion: @escaping ErrorHanlder) {
        
        HTTPClient.shared.request(UserRequest.register(
            email: email, password: password, name: name), completion: { result in
                
                switch result {
                    
                case .success: break
        
                case .failure(let error):
//                    do {
//                        let errorResponse = try JSONDecoder().decode(
//                            RegisterError.self,
//                            from: data
//                        )
//
//                        DispatchQueue.main.async {
//
//                            completion(Result.success(errorResponse))
//                        }
//
//                    } catch {
//                        print(error)
//                        completion(Result.failure(error))
//                    }
                    
                    print(error)
                    completion(Result.failure(error))
                }
            })
    }
    
    // MARK: - POST TO Login
    func postToLogin(email: String,
                     password: String, completion: @escaping LoginHanlder) {
        
        HTTPClient.shared.request(UserRequest.login(
            email: email, password: password), completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let loginResponse = try JSONDecoder().decode(
                            Token.self,
                            from: data
                        )
                        
                        KeyChainManager.shared.token = loginResponse.token
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(loginResponse))
                        }
                        
                    } catch {
                        print(error)
                        completion(Result.failure(error))
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(Result.failure(error))
                    
                }
            })
    }
}
