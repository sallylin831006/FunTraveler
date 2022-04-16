//
//  TripRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import Foundation

enum TripRequest: STRequest {

    case getTrip(token: String)
    
    case addTrip(token: String, title: String, startDate: String, endDate: String)
    
    case getSchdule(token: String, tripId: Int)

    var headers: [String: String] {

        switch self {

        case .getTrip(let token), .addTrip(let token, _, _, _), .getSchdule(let token, _):
            
            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]

        }
    }

    var body: Data? {

        switch self {

        case .getTrip, .getSchdule: return nil
            
        case .addTrip(_, let title, let startDate, let endDate):
            
            let body = [
                "title": title,
                "start_date": startDate,
                "end_date": endDate
              ]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)

        }
    }

    var method: String {

        switch self {

        case .getTrip, .getSchdule : return STHTTPMethod.GET.rawValue
        case .addTrip: return STHTTPMethod.POST.rawValue

        }
    }

    var endPoint: String {

        switch self {
        
        case .getTrip:
            return "/api/v1/trips"
            
        case .getSchdule(_, let tripId):
            return "/api/v1/trips/\(tripId)"
            
        case .addTrip:
            return "/api/v1/trips"
        
        }
        
    }

}
