//
//  TripRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import Foundation

enum TripRequest: STRequest {

    case getTrip(token: String)
    
    case getSchdule(token: String, tripId: Int)

    var headers: [String: String] {

        switch self {

        case .getTrip(let token), .getSchdule(let token, _):
            
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]

        }
    }

    var body: Data? {

        switch self {

        case .getTrip, .getSchdule: return nil

        }
    }

    var method: String {

        switch self {

        case .getTrip, .getSchdule : return STHTTPMethod.GET.rawValue

        }
    }

    var endPoint: String {

        switch self {
        
        case .getTrip:
            return "/api/v1/trips"
            
        case .getSchdule(_, let tripId):
            return "/api/v1/trips/\(tripId)"
        
        }
        
    }

}
