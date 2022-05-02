//
//  TripProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import Foundation
import UIKit

typealias TripHanlder = (Result<Trips>) -> Void
typealias AddTripHanlder = (Result<AddTrip>) -> Void
typealias ScheduleInfoHanlder = (Result<ScheduleInfo>) -> Void
typealias ResponseHanlder = (Result<String>) -> Void

class TripProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - GET USER TRIP OVERVIEW
    func fetchTrip(completion: @escaping TripHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(
            TripRequest.getTrip(token: token) ,
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
    func addTrip(title: String, startDate: String, endDate: String, completion: @escaping AddTripHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(
            TripRequest.addTrip(token: token, title: title, startDate: startDate, endDate: endDate),
            completion: { result in
               
                switch result {
                    
                case .success(let data):
                    
                    do {

                        let addTrip = try JSONDecoder().decode(
                            AddTrips.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(addTrip.data))
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
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(
            TripRequest.getSchdule(token: token, tripId: tripId, days: days) ,
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
    func postTrip(tripId: Int, schedules: [Schedule], day: Int, completion: @escaping ScheduleInfoHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(
            TripRequest.postTrip(token: token,
                                 tripId: tripId,
                                 schedules: schedules,
                                 day: day), completion: {  result in
               
                switch result {
                    
                case .success(let data) :
                    
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
    
    // MARK: - PATCH to Update and publish schedules
    func updateTrip(tripId: Int, schedules: [Schedule], isPrivate: Bool, isPublish: Bool, completion: @escaping ResponseHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(
            TripRequest.updateTrip(token: token, tripId: tripId, schedules: schedules, isPrivate: isPrivate, isPublish: isPublish), completion: {  result in
               
                switch result {
                    
                case .success : break
                                    
                case .failure(let error):
                    print(error)
                    completion(Result.failure(error))
                    
                }
            })
    }
    
    // MARK: - POST TO COPY TRIP
    func copyTrip(title: String, startDate: String, endDate: String, tripId: Int, completion: @escaping ScheduleInfoHanlder) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(
            TripRequest.copyTrip(token: token, title: title, startDate: startDate, endDate: endDate, tripId: tripId),
            completion: { result in
               
                switch result {
                    
                case .success(let data):
                    
                    do {

                        let copyTrip = try JSONDecoder().decode(
                            ScheduleInfo.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(copyTrip))
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
