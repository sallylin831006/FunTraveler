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
    func addCollected(token: String, isCollected: Bool, tripId: Int, completion: @escaping CollectedHanlder) {
        
        HTTPClient.shared.request(
            CollectedRequest.postCollected(
                token: "mockToken", isCollected: isCollected, tripId: tripId), completion: { result in
                    
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
    func fetchCollected(token: String, completion: @escaping ExploreCollectedHanlder) {
        
        HTTPClient.shared.request(
            CollectedRequest.getCollected(token: "mockToken"), completion: { result in
                
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
