//
//  ReactionProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/26.
//

import Foundation
import UIKit

typealias PostCommentHanlder = (Result<String>) -> Void
typealias CommentHanlder = (Result<Comments>) -> Void

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
    
    
    
}
