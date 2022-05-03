//
//  ReactionProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/26.
//

import Foundation
import UIKit

typealias PostCommentHanlder = (Result<Comment>) -> Void
typealias CommentHanlder = (Result<Comments>) -> Void
typealias LikedHanlder = (Result<User>) -> Void

class ReactionProvider {
    
    let decoder = JSONDecoder()
    // MARK: - POST TO ADD COMMENTS
    func postToComment(content: String, tripId: Int, completion: @escaping PostCommentHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(
            ReactionRequest.postComment(token: token, content: content, tripId: tripId), completion: { result in
                
                switch result {
                    
                case .success(let data):
                    do {
                        let commentResponse = try JSONDecoder().decode(
                            SingleCmment.self,
                            from: data
                        )
                                                
                        DispatchQueue.main.async {
                            
                            completion(Result.success(commentResponse.data))
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
    // MARK: - DELETE COMMENTS
    func deleteComment(tripId: Int, commentId: Int, completion: @escaping PostCommentHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(
            ReactionRequest.deleteComment(token: token, commentId: commentId, tripId: tripId), completion: { result in
                
                switch result {
                    
                case .success: break
                    
                case .failure(let error):
                    print(error)
                    completion(Result.failure(error))
                    
                }
            })
    }
        
    // MARK: - GET COMMENTS
    func fetchComment(tripId: Int, completion: @escaping CommentHanlder) {
        
        HTTPClient.shared.request(
            ReactionRequest.getComment(tripId: tripId), completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let commentData = try JSONDecoder().decode(
                            Comments.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(commentData))
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
    
    // MARK: - POST TO Liked
    func postToLiked(tripId: Int, completion: @escaping (Result<String>) -> Void) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(
            ReactionRequest.postLiked(token: token, tripId: tripId), completion: { result in
                
                switch result {
                    
                case .success: break
                    
                case .failure(let error):
                    print(error)
                    completion(Result.failure(error))
                    
                }
            })
    }
    
    // MARK: - DELETE UnLiked
    
    func deleteUnLiked(tripId: Int, completion: @escaping (Result<String>) -> Void) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(
            ReactionRequest.deleteUnLiked(token: token, tripId: tripId), completion: { result in
                
                switch result {
                    
                case .success: break
                    
                case .failure(let error):
                    print(error)
                    completion(Result.failure(error))
                    
                }
            })
    }
    
    // MARK: - GET Liked
    func fetchLiked(token: String, tripId: Int, completion: @escaping LikedHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
            
        }
       
        HTTPClient.shared.request(
            ReactionRequest.getLiked(token: token, tripId: tripId), completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let commentData = try JSONDecoder().decode(
                            User.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(commentData))
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
