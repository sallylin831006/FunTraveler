//
//  MapObject.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/12.
//

import Foundation

struct GoogleMapResponse: Codable {
    var results: [Results]
    var status: String
}

struct Results: Codable {
    var geometry: Geometry
    var name: String
    var rating: Double?
    var vicinity: String
    var placeId: String
    
    enum CodingKeys: String, CodingKey {
        case geometry, name, rating, vicinity
        case placeId = "place_id"
    }
}

struct Geometry: Codable {
    var location: Location
}

struct Location: Codable {
    var lat: Float
    var lng: Float
}

struct DetailResponse: Codable {
    var result: DetailResults
}

struct DetailResults: Codable {
    var businessStatus: String
    var address: String
    var geometry: Geometry
    var name: String
    var photos: [PhotosResults]
    var rating: Double?
    var reviews: [Reviews]
    
    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case address = "formatted_address"
        case geometry, name, photos, rating, reviews
    }
    
}

struct PhotosResults: Codable {
    var photoReference: String
    
    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }
}

struct Reviews: Codable {
    var authorName: String
    var photoUrl: String
    var description: String
    var text: String
    
    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case photoUrl = "profile_photo_url"
        case description = "relative_time_description"
        case text
        
    }
}
