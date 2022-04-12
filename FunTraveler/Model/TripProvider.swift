//
//  TripProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import Foundation
import UIKit

typealias TripHanlder = (Result<Trips>) -> Void

class TripProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - Public method
    func fetchTrip(completion: @escaping TripHanlder) {
        
        HTTPClient.shared.request(
            TripRequest.getTrip(token: "mockToken") ,
            completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
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
    
    // MARK: - Public method
    func fetchSchedule(tripId: Int, completion: @escaping TripHanlder) {
        
        HTTPClient.shared.request(
            TripRequest.getSchdule(token: "mockToken", tripId: tripId) ,
            completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {

                        let tripSchedule = try JSONDecoder().decode(
                            Trips.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(tripSchedule))
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
