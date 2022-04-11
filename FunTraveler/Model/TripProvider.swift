//
//  TripProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import Foundation
import UIKit

struct Trips: Codable {
    var data: [Trip]
}

struct Trip: Codable {
    var id: Int
    var title: String
    var days: Int
}

typealias TripHanlder = (Result<Trips>) -> Void

class TripProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - Public method
    func fetchTrip(completion: @escaping TripHanlder) {
        
        HTTPClient.shared.request(
            TripRequest.getTrip(token: "mockToken") ,
            completion: { result in  // completion: { [weak self] result in
                
                // guard let strongSelf = self else { return }
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        // let products = try strongSelf.decoder.decode(
                        let tripData = try JSONDecoder().decode(
                            Trips.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(tripData))
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
