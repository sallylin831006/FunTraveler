//
//  TabBarViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/15.
//

import UIKit

private enum Tab {
    case explore
    
    case planOverView
    
    case profile
    
    case video
    
    case camera

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {
            
        case .explore: controller = UIStoryboard.explore.instantiateInitialViewController()!
            
        case .planOverView: controller = UIStoryboard.planOverView.instantiateInitialViewController()!

        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!

        case .video: controller = UIStoryboard.video.instantiateInitialViewController()!
            
        case .camera: controller = UIStoryboard.camera.instantiateInitialViewController()!
        }

        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {
            
        case .explore:
            return UITabBarItem(
                title: "探索",
                image: UIImage.asset(.exploreNormal),
                selectedImage: UIImage.asset(.exploreSelected)
            )
            
        case .planOverView:
            return UITabBarItem(
                title: "行程",
                image: UIImage.asset(.tripNormal),
                selectedImage: UIImage.asset(.tripSelected)
            )
            
        case .profile:
            return UITabBarItem(
                title: "個人",
                image: UIImage.asset(.profileNormal),
                selectedImage: UIImage.asset(.profileSelected)
            )
            
        case .video:
            return UITabBarItem(
                title: "動態",
                image: UIImage.asset(.collectNormal),
                selectedImage: UIImage.asset(.collectSelected)
            )
            
        case .camera:
            return UITabBarItem(
                title: "相機",
                image: UIImage.asset(.cameraNormal),
                selectedImage: UIImage.asset(.cameraSelected)
            )
        }
    }
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private let tabs: [Tab] = [.explore, .video, .camera, .planOverView, .profile ]
    
    var trolleyTabBarItem: UITabBarItem!
    
    var orderObserver: NSKeyValueObservation!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })

        trolleyTabBarItem = viewControllers?[0].tabBarItem
        
        trolleyTabBarItem.badgeColor = .brown

        delegate = self
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.themeApricotDeep
            
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        tabBar.frame.size.height = 90
//        tabBar.frame.origin.y = view.frame.height - 90
        tabBar.tintColor = .black
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = true
        tabBar.backgroundColor = .themeApricotDeep
    }

    // MARK: - UITabBarControllerDelegate

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {

        return true
    }
}
