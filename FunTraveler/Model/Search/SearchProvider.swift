//
//  SearchProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/12.
//

import Foundation
import UIKit

typealias SearchHanlder = (Result<GoogleMapResponse>) -> Void
typealias SearchDetailHanlder = (Result<DetailResponse>) -> Void

class SearchProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - Public method
    func fetchSearch(keyword: String, position: String, radius: Int, completion: @escaping SearchHanlder) {
//
//      let searchMockData = GoogleMapResponse(results: [Results(
//        geometry: Geometry(location: Location(lat: 25.040895, lng: 121.556335)),
//        name: "Lady M 旗艦店", rating: Optional(3.9),
//        userRatingsTotal: 2773, vicinity: "大安區光復南路240巷26號", placeId: "ChIJe2UCUMarQjQRdymATStlwUA"),
//                                                       Results(
//            geometry: Geometry(location: Location(lat: 25.029398, lng: 121.56259)),
//            name: "幸福微甜手做diy烘焙屋", rating: Optional(4.4),
//            userRatingsTotal: 2773, vicinity: "信義區莊敬路253號1樓", placeId: "ChIJe2UCUMarQjQRdymATStlwUA"),
//                                                       Results(
//            geometry: Geometry(location: Location(lat: 25.041012, lng: 121.56516)),
//            name: "YTM亞尼克蛋糕提領站(市政府站)", rating: Optional(2.0),
//            userRatingsTotal: 2773, vicinity: "信義區忠孝東路五段2號", placeId: "ChIJe2UCUMarQjQRdymATStlwUA"),
//                                                       Results(
//            geometry: Geometry(location: Location(lat: 25.036215, lng: 121.56727)),
//            name: "起士公爵 乳酪蛋糕/彌月蛋糕/無麩質甜點", rating: Optional(5.0),
//            userRatingsTotal: 2773, vicinity: "信義區松壽路11號", placeId: "ChIJe2UCUMarQjQRdymATStlwUA"),
//                                                       Results(
//            geometry: Geometry(location: Location(lat: 25.036215, lng: 121.56727)),
//            name: "起士公爵 乳酪蛋糕/彌月蛋糕/無麩質甜點", rating: Optional(5.0),
//            userRatingsTotal: 2773, vicinity: "信義區松壽路11號", placeId: "ChIJe2UCUMarQjQRdymATStlwUA"),
//                                                       Results(
//            geometry: Geometry(location: Location(lat: 25.036215, lng: 121.56727)),
//            name: "起士公爵 乳酪蛋糕/彌月蛋糕/無麩質甜點", rating: Optional(5.0),
//            userRatingsTotal: 2773, vicinity: "信義區松壽路11號", placeId: "ChIJe2UCUMarQjQRdymATStlwUA"),
//                                                       Results(
//            geometry: Geometry(location: Location(lat: 25.036215, lng: 121.56727)),
//            name: "起士公爵 乳酪蛋糕/彌月蛋糕/無麩質甜點", rating: Optional(5.0),
//            userRatingsTotal: 2773, vicinity: "信義區松壽路11號", placeId: "ChIJe2UCUMarQjQRdymATStlwUA")
//                                                      ],
//                                             status: "OK")
//        completion(Result.success(searchMockData))
//        return
//
//        // ----mock Data -----//
  
        HTTPClient.shared.maprequest(
            SearchRequest.mapSearch(keyword: keyword, position: position, radius: radius),
            completion: { result in

                switch result {

                case .success(let data):

                    do {
                        let searchData = try JSONDecoder().decode(
                            GoogleMapResponse.self,
                            from: data
                        )

                        DispatchQueue.main.async {

                            completion(Result.success(searchData))
                        }

                    } catch {
                        print(error)
                        completion(Result.failure(error))
                    }

                case .failure(let error):
                    print(error)
                    completion(Result.failure(error))

                }
            })
    }
    
    // MARK: - Public method
    func fetchSearchDetail(placeId: String, completion: @escaping SearchDetailHanlder) {
        
        HTTPClient.shared.maprequest(
            SearchRequest.searchDetail(placeId: placeId),
            completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let searchDetails = try JSONDecoder().decode(
                            DetailResponse.self,
                            from: data
                        )
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(searchDetails))
                        }
                        
                    } catch {
                        print(error)
                        completion(Result.failure(error))
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(Result.failure(error))
                    
                }
            })
    }
    
    // MARK: - Public method
    func fetchPhotos(maxwidth: Int, photoreference: String, completion: @escaping (UIImage?) -> Void) {
        
        HTTPClient.shared.maprequest(
            SearchRequest.searchPhoto(maxwidth: maxwidth, photoreference: photoreference),
            completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    let searchPhotos = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        
                        completion(searchPhotos)
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(error as? UIImage)
                    
                }
            })
    }
    
}
