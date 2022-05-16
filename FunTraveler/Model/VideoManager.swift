//
//  APIManager.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/23.
//

import Foundation

class VideoManager: NSObject {
    
    var downloadCompletionBlock: ((_ data: Data) -> Void)?
    
    func requestWithFormData(urlString: String, parameters: [String: Any], dataPath: [String: Data], completion: @escaping (Data) -> Void) {

        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary+\(arc4random())\(arc4random())"
        var body = Data()
        
        guard let token = KeyChainManager.shared.token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: STHTTPHeaderField.auth.rawValue)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        for (key, value) in dataPath {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(
                string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(arc4random())\"\r\n")
            body.appendString(string: "Content-Type: video/mov\r\n\r\n")
            body.append(value)
            body.appendString(string: "\r\n")
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        request.httpBody = body
        
        fetchedDataByDataTask(from: request, completion: completion)
        
    }
    
    private func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if error != nil {
                ProgressHUD.showFailure(text: "上傳失敗")
                print("Upload video error:", error as Any)
            } else {
                guard let data = data else { return }
                completion(data)
            }
        }
        task.resume()
    }
    
}

extension Data {
    func parseData() -> NSDictionary {
        
        let dataDict = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? NSDictionary
        
        return dataDict!
    }
    
    mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
