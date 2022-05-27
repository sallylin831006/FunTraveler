//
//  CoEditProvider.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/2.
//

import UIKit

typealias CoEditHanlder = (Result<User>) -> Void

class CoEditProvider {
    
    let decoder = JSONDecoder()
    
    // MARK: - POST TO Add Co-Editor
    func postToAddEditor(tripId: Int,
                         editorId: Int, completion: @escaping CoEditHanlder) {
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(CoEditRequest.addEditor(
            token: token, tripId: tripId, editorId: editorId), completion: { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        let coEditorResponse = try JSONDecoder().decode(
                            Users.self, from: data)
                        
                        DispatchQueue.main.async {
                            
                            completion(Result.success(coEditorResponse.data))
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
    
    // MARK: - DELETE Co-Editor
    func deleteCoEditor(tripId: Int,
                        editorId: Int, completion: @escaping (Result<String>) -> Void) {
        
        guard let token = KeyChainManager.shared.token else {
            
            return completion(Result.failure(FunTravelerSignInError.noToken))
        }
        
        HTTPClient.shared.request(CoEditRequest.removeEditor(
            token: token, tripId: tripId, editorId: editorId), completion: { result in
                
                switch result {
                    
                case .success:
                    
                    DispatchQueue.main.async {
                        
                        completion(Result.success("success"))
                    }
                    
                case .failure(let error):
                    
                    print(error)
                    completion(Result.failure(error))
                }
            })
    }
    
}
