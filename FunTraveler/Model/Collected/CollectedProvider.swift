//
//  CollectedProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/20.
//

import Foundation
import UIKit

typealias CollectedHanlder = (Result<String>) -> Void

class CollectedProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - POST TO ADD NEW COLLECTED
    func addCollected(token: String, isCollected: Bool, tripId: Int, completion: @escaping CollectedHanlder) {
        
        HTTPClient.shared.request(
            CollectedRequest.collectedTrip(
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
}
