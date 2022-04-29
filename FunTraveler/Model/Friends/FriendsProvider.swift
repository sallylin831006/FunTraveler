//
//  FriendsProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/29.
//

import UIKit

typealias FriendHanlder = (Result<Friends>) -> Void

class FriendsProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - POST TO Invite Friends
    func postToInvite(userId: Int, completion: @escaping (Result<String>) -> Void) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(FriendsRequest.postToInvite(token: token, userId: userId), completion: { result in
            
            switch result {
                
            case .success: break
                
            case .failure(let error):
                
                print(error)
                completion(Result.failure(error))
            }
        })
    }
    
    // MARK: - POST TO Accept Friends
    func postToAccept(userId: Int,
                      isAccept: Bool, completion: @escaping (Result<String>) -> Void) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(FriendsRequest.postToAccept(token: token, userId: userId, isAccept: isAccept), completion: { result in
            
            switch result {
                
            case .success: break
                
            case .failure(let error):
                print(error)
                completion(Result.failure(error))
                
            }
        })
    }
    
    // MARK: - Get Invite List
    func getInviteList(completion: @escaping FriendHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(FriendsRequest.getInviteList(token: token), completion: { result in
            
            switch result {
                
            case .success(let data):
                
                do {
                    let inviteResponse = try JSONDecoder().decode(Friends.self, from: data
                    )
                    
                    DispatchQueue.main.async {
                        completion(Result.success(inviteResponse))
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
    
    // MARK: - GET Friend List
    func getFriendList(completion: @escaping FriendHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(FriendsRequest.getInviteList(token: token), completion: { result in
            
            switch result {
                
            case .success(let data):
                
                do {
                    let firendsResponse = try JSONDecoder().decode(Friends.self, from: data
                    )
                    
                    DispatchQueue.main.async {
                        completion(Result.success(firendsResponse))
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
