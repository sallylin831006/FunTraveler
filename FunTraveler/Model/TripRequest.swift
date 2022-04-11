//
//  TripRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import Foundation

enum TripRequest: STRequest {

    case getTrip(token: String)
    

    var headers: [String: String] {

        switch self {

        case .getTrip(let token):
            
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]

        }
    }

    var body: Data? {

        switch self {

        case .getTrip: return nil

        }
    }

    var method: String {

        switch self {

        case .getTrip : return STHTTPMethod.GET.rawValue

        }
    }

    var endPoint: String {

        switch self {
        
        case .getTrip:
            return "/api/v1/trips"
        
        }
        
    
    }

}
