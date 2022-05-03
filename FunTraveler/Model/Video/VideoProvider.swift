//
//  VideoProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/24.
//

import Foundation
import UIKit

typealias VideoHanlder = (Result<[Video]>) -> Void

class VideoProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - GET Collected
    func fetchVideo(completion: @escaping VideoHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(
            VideoRequest.getVideo(token: token), completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let getVideoData = try JSONDecoder().decode(
                            Videos.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(getVideoData.data))
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
