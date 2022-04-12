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

struct Trip: Codable {
    var id: Int
    var title: String
    var days: Int
    
    var startDate: String?
    var endDate: String?
    var schedules: [[Schedule]]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, days, schedules
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

struct Schedule: Codable {
    var name: String
    var address: String
    var startTime: String
    var duration: Double
    var type: String

    enum CodingKeys: String, CodingKey {
        case name, address, duration, type
        case startTime = "start_time"
        
    }
}
