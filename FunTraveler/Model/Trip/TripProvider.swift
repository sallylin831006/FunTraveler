//
//  TripProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import Foundation
import UIKit

typealias TripHanlder = (Result<Trips>) -> Void
typealias ScheduleInfoHanlder = (Result<ScheduleInfo>) -> Void
typealias ResponseHanlder = (Result<String>) -> Void

class TripProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - GET USER TRIP OVERVIEW
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
    
    // MARK: - POST TO ADD NEW TRIP
    func addTrip(title: String, startDate: String, endDate: String, completion: @escaping ScheduleInfoHanlder) {
        
        HTTPClient.shared.request(
            TripRequest.addTrip(token: "mockToken", title: title, startDate: startDate, endDate: endDate),
            completion: { result in
               
                switch result {
                    
                case .success(let data):
                    
                    do {

                        let addTrip = try JSONDecoder().decode(
                            ScheduleInfo.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(addTrip))
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
    func fetchSchedule(tripId: Int, days: Int, completion: @escaping ScheduleInfoHanlder) {
        
        HTTPClient.shared.request(
            TripRequest.getSchdule(token: "mockToken", tripId: tripId, days: days) ,
            completion: { result in

                switch result {
                    
                case .success(let data):
                    
                    do {

                        let tripSchedule = try JSONDecoder().decode(
                            ScheduleInfo.self,
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
    
    // MARK: - POST TO BUILD SCHEDULES FOR TRIP
    func postTrip(tripId: Int, schedules: [Schedule], day: Int, completion: @escaping TripHanlder) {
        
        HTTPClient.shared.request(
            TripRequest.postTrip(token: "mockToken",
                                 tripId: tripId,
                                 schedules: schedules,
                                 day: day), completion: {  result in
               
                switch result {
                    
                case .success(let data) :
                    
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
    
    // MARK: - PATCH to Update and publish schedules
    func updateTrip(tripId: Int, schedules: [Schedule], completion: @escaping ResponseHanlder) {
        
        HTTPClient.shared.request(
            TripRequest.updateTrip(token: "mockToken",
                                   tripId: tripId,
                                   schedules: schedules), completion: {  result in
               
                switch result {
                    
                case .success :
                    
                    print("updateTrip SUCCESS!")
                    
                case .failure(let error):
                    print(error)
                    completion(Result.failure(error))
                    
                }
            })
    }

}
