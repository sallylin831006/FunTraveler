//
//  TripObject.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import Foundation

// --- GET TRIP OVERVIEW ---//
struct Trips: Codable {
    var data: [Trip]
}

// --- GET TRIP DETAIL ---//
struct ScheduleInfo: Codable {
    var data: Trip
}

struct Trip: Codable {
    var id: Int
    var days: Int?
    var title: String
    var startDate: String?
    var endDate: String?
    
    var schedules: [[Schedule]]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, schedules
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

struct Schedule: Codable {
    var name: String
    var address: String
    var startTime: String
    var duration: Double
    var trafficTime: Double
    var type: String
    var position: Position

    enum CodingKeys: String, CodingKey {
        case name, address, duration, type, position
        case startTime = "start_time"
        case trafficTime = "traffic_time"
        
    }
}

struct Position: Codable {
    var lat: Double
    var long: Double
}