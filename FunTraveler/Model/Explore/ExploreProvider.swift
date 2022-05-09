//
//  ExploreProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/17.
//

import Foundation
import UIKit

typealias ExploreHanlder = (Result<[Explore]>) -> Void

class ExploreProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - GET EXPLORE TRIPS
    func fetchExplore(completion: @escaping ExploreHanlder) {
        
        let token = KeyChainManager.shared.token ?? ""
        
        HTTPClient.shared.request(
            ExploreRequest.getExplore(token: token), completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let exploreData = try JSONDecoder().decode(
                            Explores.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(exploreData.data))
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
    
    // MARK: - POST TO SEARCH TRIPS
    func postToSearch(word: String, completion: @escaping ExploreHanlder) {
        
        HTTPClient.shared.request(
            ExploreRequest.searchTrips(word: word), completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let searchData = try JSONDecoder().decode(
                            Explores.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(searchData.data))
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
