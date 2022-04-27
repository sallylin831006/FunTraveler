//
//  CollectedProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/20.
//

import Foundation
import UIKit

typealias CollectedHanlder = (Result<String>) -> Void
typealias ExploreCollectedHanlder = (Result<Explores>) -> Void

class CollectedProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - POST TO ADD NEW COLLECTED
    func addCollected(isCollected: Bool, tripId: Int, completion: @escaping CollectedHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(
            CollectedRequest.postCollected(
                token: token, isCollected: isCollected, tripId: tripId), completion: { result in
                    
                    switch result {
                        
                    case .success:
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(token))
                        }
                        
                    case .failure(let error):
                        print(error)
                        completion(Result.failure(error))
                        
                    }
                })
    }
    
    // MARK: - GET Collected
    func fetchCollected(completion: @escaping ExploreCollectedHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(
            CollectedRequest.getCollected(token: token), completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let exploreCollectedData = try JSONDecoder().decode(
                            Explores.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(exploreCollectedData))
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
