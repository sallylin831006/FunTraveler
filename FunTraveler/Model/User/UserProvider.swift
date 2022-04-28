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

typealias UserHanlder = (Result<Users>) -> Void

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
    
    // MARK: - Sing in with apple
    func siginInwithApple(appleToken: String, completion: @escaping LoginHanlder) {

        HTTPClient.shared.request(UserRequest.appleLogin(appleToken: appleToken), completion: { result in
                
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
    
    // MARK: - GET USER PROFILE
    func getProfile(userId: Int, completion: @escaping UserHanlder) {
        
        let token = KeyChainManager.shared.token ?? ""
        
        HTTPClient.shared.request(UserRequest.getProfile(token: token, userId: userId), completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let profileResponse = try JSONDecoder().decode(
                            Users.self,
                            from: data
                        )
                                                
                        DispatchQueue.main.async {
                            
                            completion(Result.success(profileResponse))
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
    
// MARK: - PATCH TO UPDATE USER PROFILE
    func updateProfile(name: String, image: String, completion: @escaping UserHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(UserRequest.updateProfile(
            token: token, name: name, image: image), completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let updateProfileResponse = try JSONDecoder().decode(
                            Users.self,
                            from: data
                        )
                                                
                        DispatchQueue.main.async {
                            
                            completion(Result.success(updateProfileResponse))
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
    
    // MARK: - DELETE USER
    func deleteUser(completion: @escaping ErrorHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(UserRequest.deleteUser(token: token), completion: { result in
                
                switch result {
                    
                case .success: break
        
                case .failure(let error):
                    print(error)
                    completion(Result.failure(error))
                }
            })
    }
}
