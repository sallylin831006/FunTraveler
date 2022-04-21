//
//  AppDelegate.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit
import IQKeyboardManagerSwift
import PusherSwift
//import GoogleMaps
//import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PusherDelegate {
    
    var pusher: Pusher!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
//        GMSPlacesClient.provideAPIKey(KeyConstants.mapKey)
//        GMSServices.provideAPIKey(KeyConstants.mapKey)
        
    // MARK: - PusherSwift
        let options = PusherClientOptions(
                host: .cluster("ap3")
              )

              pusher = Pusher(
                key: KeyConstants.pusherKey,
                options: options
              )

              pusher.delegate = self

              // subscribe to channel
              let channel = pusher.subscribe("trip")

              // bind a callback to handle an event
              let _ = channel.bind(eventName: "server.updated", eventCallback: { (event: PusherEvent) in
                  if let data = event.data {
                    // you can parse the data as necessary
                    print("Pusher Data:", data)
                      
                      
                      
                  }
              })

              pusher.connect()
        return true
    }
    // print Pusher debug messages
        func debugLog(message: String) {
          print(message)
        }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }

}
