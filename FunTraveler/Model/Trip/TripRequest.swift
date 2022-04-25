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
    
    case getSchdule(token: String, tripId: Int, days: Int)
    
    case postTrip(token: String, tripId: Int, schedules: [Schedule], day: Int)
    
    case updateTrip(token: String, tripId: Int, schedules: [Schedule])
    
    case copyTrip(token: String, title: String, startDate: String, endDate: String, tripId: Int)
    
    var headers: [String: String] {
        
        switch self {
            
        case .getTrip(let token),
                .addTrip(let token, _, _, _),
                .getSchdule(let token, _, _),
                .postTrip(let token, _, _, _),
                .updateTrip(let token, _, _),
                .copyTrip(let token, _, _, _, _):
            
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
            
        case .postTrip(_, _, let schedules, let day):
            var scheduleData: [[String: Any]] = []
            
            for schedule in schedules {
                scheduleData.append([
                    "name": schedule.name,
                    "address": schedule.address,
                    "start_time": schedule.startTime,
                    "duration": schedule.duration,
                    "traffic_time": schedule.trafficTime,
                    "type": schedule.type,
                    "position": [
                        "lat": schedule.position.lat,
                        "long": schedule.position.long
                    ]
                ])
            }
            // let encodedSchedules = try? JSONEncoder().encode(schedules)
            
            let body = [
                "schedules": scheduleData,
                "day": day
            ] as [String: Any]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        case .updateTrip(_, _, let schedules):
            var scheduleData: [[String: Any]] = []
            
            for schedule in schedules {
                scheduleData.append([
                    "id": schedule.id,
                    "description": schedule.description,
                    "images": schedule.images
                ]
                )
            }
            
            let body = [
                "schedules": scheduleData
            ] as [String: Any]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
            
            
        case .copyTrip(_, let title, let startDate, let endDate, let tripId):
            
            let body = [
                "title": title,
                "start_date": startDate,
                "end_date": endDate,
                "trip_id": tripId
            ] as [String: Any]
            
            return try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
    }
    
    var method: String {
        
        switch self {
            
        case .getTrip : return STHTTPMethod.GET.rawValue
        case .getSchdule : return STHTTPMethod.GET.rawValue
        case .addTrip: return STHTTPMethod.POST.rawValue
        case .postTrip: return STHTTPMethod.POST.rawValue
        case .updateTrip: return STHTTPMethod.PATCH.rawValue
        case .copyTrip: return STHTTPMethod.POST.rawValue

        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .getTrip:
            return "/api/v1/trips"
            
        case .getSchdule(_, let tripId, let days):
            return "/api/v1/trips/\(tripId)?day=\(days)"
            
        case .addTrip:
            return "/api/v1/trips"
            
        case .postTrip(_, let tripId, _, _):
            return "/api/v1/trips/\(tripId)"
            
        case .updateTrip(_, let tripId, _):
            return "/api/v1/trips/\(tripId)"
            
        case .copyTrip:
            return "/api/v1/trips/duplicate"
            
        }
        
    }
    
}
