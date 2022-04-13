//
//  SearchRequest.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/12.
//

import Foundation
enum SearchRequest: STRequest {

    case mapSearch(keyword: String, position: String, radius: Int)
    
    case searchDetail(placeId: String)
    
    case searchPhoto(maxwidth: Int, photoreference: String)

    var headers: [String: String] {

        switch self {

        case .mapSearch, .searchDetail, .searchPhoto : return [:]

        }
    }

    var body: Data? {

        switch self {

        case .mapSearch, .searchDetail, .searchPhoto: return nil

        }
    }

    var method: String {

        switch self {

        case .mapSearch, .searchDetail, .searchPhoto: return STHTTPMethod.GET.rawValue

        }
    }

    var endPoint: String {

        switch self {
        
        case .mapSearch(let keyword, let position, let radius):
            return "/place/nearbysearch/json?location=\(position)&radius=\(radius)&keyword=\(keyword)&language=zh-TW&key=\(MapConstants.mapKey)"
                        
        case .searchDetail(let placeId):

            return "/place/details/json?place_id=\(placeId)&language=zh-TW&key=\(MapConstants.mapKey)"
            
        case .searchPhoto(let maxwidth, let photoreference):
            
            return "/place/photo?maxwidth=\(maxwidth)&&photoreference=\(photoreference)&key=\(MapConstants.mapKey)"
      
        }
        
    }

}
