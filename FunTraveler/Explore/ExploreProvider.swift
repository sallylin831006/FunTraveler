//
//  ExploreProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/17.
//

import Foundation
import UIKit

typealias ExploreHanlder = (Result<Explores>) -> Void

class ExploreProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - GET EXPLORE TRIPS
    func fetchExplore(completion: @escaping ExploreHanlder) {
        
        HTTPClient.shared.request(
            ExploreRequest.getExplore, completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let exploreData = try JSONDecoder().decode(
                            Explores.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(exploreData))
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
