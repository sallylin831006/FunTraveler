//
//  AppDelegate.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit
import IQKeyboardManagerSwift
import PusherSwift
import GoogleMaps
import GooglePlaces
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PusherDelegate {
    
    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarViewController()
        window?.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true
        GMSPlacesClient.provideAPIKey(KeyConstants.mapKey)
        GMSServices.provideAPIKey(KeyConstants.mapKey)
        FirebaseApp.configure()
        
        return true
    }
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:] ) -> Bool {
        // Determine who sent the URL.
        let sendingAppID = options[.sourceApplication]
        print("source application = \(sendingAppID ?? "Unknown")")
        
        // Process the URL.
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let albumPath = components.path,
              let params = components.queryItems else {
                  print("Invalid URL or album path missing")
                  return false
              }
        
        if let photoIndex = params.first(where: { $0.name == "index" })?.value {
            print("albumPath = \(albumPath)")
            print("photoIndex = \(photoIndex)")
            return true
        } else {
            print("Photo index missing")
            return false
        }
    }
    
}
