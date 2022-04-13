//
//  SearchProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/12.
//

import Foundation
import UIKit

typealias SearchHanlder = (Result<GoogleMapResponse>) -> Void
typealias SearchDetailHanlder = (Result<DetailResponse>) -> Void

class SearchProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - Public method
    func fetchSearch(keyword: String, position: String, radius: Int, completion: @escaping SearchHanlder) {
        
        HTTPClient.shared.request(
            SearchRequest.mapSearch(keyword: keyword, position: position, radius: radius),
            completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let searchData = try JSONDecoder().decode(
                            GoogleMapResponse.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(searchData))
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
    
    // MARK: - Public method
    func fetchSearchDetail(placeId: String, completion: @escaping SearchDetailHanlder) {
        
        HTTPClient.shared.request(
            SearchRequest.searchDetail(placeId: placeId),
            completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let searchDetails = try JSONDecoder().decode(
                            DetailResponse.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(searchDetails))
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
    
    // MARK: - Public method
    func fetchPhotos(maxwidth: Int, photoreference: String, completion: @escaping (UIImage?) -> Void) {
        
        HTTPClient.shared.request(
            SearchRequest.searchPhoto(maxwidth: maxwidth, photoreference: photoreference),
            completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let searchPhotos = UIImage(data: data)
                        
                        DispatchQueue.main.async {
                            
                            completion(searchPhotos)
                        }
                        
                    } catch {
                        print(error)
                        completion(error as? UIImage)
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(error as? UIImage)
                    
                }
            })
    }
    
}
