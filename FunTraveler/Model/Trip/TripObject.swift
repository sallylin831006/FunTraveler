//
//  TripObject.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import Foundation

struct Trips: Codable {
    var data: [Trip]
}

struct ScheduleInfo: Codable {
    var data: Trip
}

struct Trip: Codable {
    var id: Int
    var days: Int?
    var title: String?
    var startDate: String?
    var endDate: String?
    
    var schedules: [[Schedule]]?
    
    enum CodingKeys: String, CodingKey {
        case id, days, title, schedules
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

struct Schedule: Codable {
    var name: String
//    var tripId: Int?
    var day: Int
    var address: String
    var startTime: String
    var duration: Double
    var trafficTime: Double
    var type: String
    var position: Position

    enum CodingKeys: String, CodingKey {
        case name, day, address, duration, type, position
//        case tripId = "trip_id"
        case startTime = "start_time"
        case trafficTime = "traffic_time"
        
    }
}

struct Position: Codable {
    var lat: Double
    var long: Double
}
