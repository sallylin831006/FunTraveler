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

struct Schedules: Codable {
    var schedules: [Schedule]
    var tripId: Int
    enum CodingKeys: String, CodingKey {
        case schedules
        case tripId = "trip_id"
    }
}

struct Trip: Codable {
    var id: Int
    var title: String
    var days: Int
    var startDate: String?
    var endDate: String?
    var editors: [User]
    var likeCount: Int?
    var commentCount: Int?
    
    var schedules: [[Schedule]]?
    
    enum CodingKeys: String, CodingKey {
        case id, days, title, schedules, editors
        case startDate = "start_date"
        case endDate = "end_date"
        case likeCount = "likes_count"
        case commentCount = "comments_count"
    }
}

struct Schedule: Codable {
    var name: String
    var scheduleId: Int?
    var day: Int
    var address: String
    var startTime: String
    var duration: Double
    var trafficTime: Double
    var type: String
    var position: Position
    var id: Int = 0
    var description: String = ""
    var images: [String] = []

    enum CodingKeys: String, CodingKey {
        case name, day, address, duration, type, position, id, description, images
        case scheduleId = "trip_id"
        case startTime = "start_time"
        case trafficTime = "traffic_time"
        
    }
}

struct Position: Codable {
    var lat: Double
    var long: Double
}
