//
//  SceneDelegate.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast
    var window: UIWindow?

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
        guard var rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
            return
        }

        // change your view controller here
        rootViewController = UIViewController()
    }
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard (scene as? UIWindowScene) == nil else { return }
        // Determine who sent the URL.
        if let urlContext = connectionOptions.urlContexts.first {

            let sendingAppID = urlContext.options.sourceApplication
            let url = urlContext.url
            print("source application = \(sendingAppID ?? "Unknown")")
            print("url = \(url)")

            // Process the URL similarly to the UIApplicationDelegate example.
        }
    }
    
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
//               options connectionOptions: UIScene.ConnectionOptions) {
//
//        guard (scene as? UIWindowScene) == nil else { return }
//    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
      
    }
    
}
