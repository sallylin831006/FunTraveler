//
//  KeyChainManger.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import KeychainAccess

class KeyChainManager {
    
    static let shared = KeyChainManager()
    
    private let service: Keychain
    
    private let serverTokenKey: String = "FuntravelerToken"
    
    private let serverToUserIdKey: String = "FuntravelerUserId"
    
    private init() {
        
        service = Keychain(service: Bundle.main.bundleIdentifier!)
    }
    
    var token: String? {
        // swiftlint:disable computed_accessors_order
        set {
            
            guard let uuid = UserDefaults.standard.value(forKey: serverTokenKey) as? String else {
                
                let uuid = UUID().uuidString
                
                UserDefaults.standard.set(uuid, forKey: serverTokenKey)
                
                service[uuid] = newValue
                
                return
            }
            
            service[uuid] = newValue
        }
        
        get {
            
            guard let serverKey = UserDefaults.standard.string(forKey: serverTokenKey) else { return nil }
            
            for item in service.allItems() {
                
                if let key = item["key"] as? String,
                   key == serverKey {
                    
                    return item["value"] as? String
                }
            }
            
            return nil
        }
    }
    
    // MARK: - UserId
    var userId: String? {
        
        set {
            
            guard let uuid = UserDefaults.standard.value(forKey: serverToUserIdKey) as? String else {
                
                let uuid = UUID().uuidString
                
                UserDefaults.standard.set(uuid, forKey: serverToUserIdKey)
                
                service[uuid] = newValue
                
                return
            }
            
            service[uuid] = newValue
        }
        
        get {
            
            guard let serverKey = UserDefaults.standard.string(forKey: serverToUserIdKey) else { return nil }
            
            for item in service.allItems() {
                
                if let key = item["key"] as? String,
                   key == serverKey {
                    
                    return item["value"] as? String
                }
            }
            
            return nil
        }
    }
    
}
