//
//  UserProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import Foundation
import UIKit

struct RegisterSeverError: Codable {
    var errorMessage: String
    enum CodingKeys: String, CodingKey {
        case errorMessage = "error_message"
    }
}

typealias RegisterErrorHanlder = (Result<RegisterError>) -> Void

typealias LoginHanlder = (Result<Token>) -> Void

typealias ErrorHanlder = (Result<RegisterSeverError>) -> Void

typealias UserHanlder = (Result<Users>) -> Void

typealias ProfileHanlder = (Result<Profile>) -> Void

typealias ProfileTripsHanlder = (Result<Explores>) -> Void

typealias UsersListHanlder = (Result<UsersList>) -> Void

enum FunTravelerSignInError: Error {
    
    case noToken
}

class UserProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - POST TO Register
    func postToRegister(email: String,
                        password: String,
                        name: String, complete: @escaping (() -> Void), failure: @escaping ErrorHanlder) {
        
        HTTPClient.shared.request(UserRequest.register(
            email: email, password: password, name: name), completion: { result in
                
                switch result {
                    
                case .success:
                    complete()
                    print("success")
                    
                case .failure(let error):
                    
                    if let error = error as? STHTTPClientError {
                        
                        switch error {
                        case .decodeDataFail: break
                            
                        case .clientError(let data):
                            do {
                                
                                let errorResponse = try JSONDecoder().decode(
                                    RegisterSeverError.self,
                                    from: data
                                )
                                
                                DispatchQueue.main.async {
                                    failure(Result.success(errorResponse))
                                }
                                
                            } catch {
                                print(error)
                                failure(Result.failure(error))
                            }
                            
                        case .serverError: break
                            
                        case .unexpectedError: break
                            
                        }
                    }
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
                        KeyChainManager.shared.userId = String(loginResponse.userId)
                        
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
                    
                    KeyChainManager.shared.userId = String(loginResponse.userId)
                    
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
    func getProfile(userId: Int, completion: @escaping ProfileHanlder) {
        
        let token = KeyChainManager.shared.token ?? ""
        
        HTTPClient.shared.request(UserRequest.getProfile(token: token, userId: userId), completion: { result in
            
            switch result {
                
            case .success(let data):
                
                do {
                    let profileResponse = try JSONDecoder().decode(
                        UserProfile.self,
                        from: data
                    )
                    
                    DispatchQueue.main.async {
                        
                        completion(Result.success(profileResponse.data))
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
    
    // MARK: - GET USER PRIVATE/PUBLIC Trips IN PROFILE
    func getProfileTrips(userId: Int, completion: @escaping ProfileTripsHanlder) {
        
        let token = KeyChainManager.shared.token ?? ""
        
        HTTPClient.shared.request(UserRequest.getProfileTrips(token: token, userId: userId), completion: { result in
            
            switch result {
                
            case .success(let data):
                
                do {
                    let profileTripsResponse = try JSONDecoder().decode(
                        Explores.self,
                        from: data
                    )
                    
                    DispatchQueue.main.async {
                        
                        completion(Result.success(profileTripsResponse))
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
    
    // MARK: - POST To Block User
    func blockUser(userId: Int, completion: @escaping (Result<String>) -> Void) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(UserRequest.blockUser(token: token, userId: userId), completion: { result in
            
            switch result {
                
            case .success:
                completion(Result.success("success"))
            case .failure(let error):
                print(error)
                completion(Result.failure(error))
                
            }
        })
    }
    
    // MARK: - DELETE To UnBlock User
    func unBlockUser(userId: Int, completion: @escaping (Result<String>) -> Void) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(UserRequest.unBlockUser(token: token, userId: userId), completion: { result in
            
            switch result {
                
            case .success: break
                
            case .failure(let error):
                print(error)
                completion(Result.failure(error))
                
            }
        })
    }
    
    // MARK: - GET Block List
    func getBlockList(completion: @escaping UsersListHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(UserRequest.getBlockList(token: token), completion: { result in
            
            switch result {
                
            case .success(let data):
                
                do {
                    let blockListResponse = try JSONDecoder().decode(
                        UsersList.self,
                        from: data
                    )
                    
                    DispatchQueue.main.async {
                        
                        completion(Result.success(blockListResponse))
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
    
    // MARK: - POST User List by Search
    func postToSearchUser(text: String, completion: @escaping UsersListHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(UserRequest.postToSearchUser(token: token, text: text), completion: { result in
            
            switch result {
                
            case .success(let data):
                
                do {
                    let userSearchList = try JSONDecoder().decode(
                        UsersList.self,
                        from: data
                    )
                    
                    DispatchQueue.main.async {
                        
                        completion(Result.success(userSearchList))
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
