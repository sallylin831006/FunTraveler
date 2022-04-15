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

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {
            
        case .explore: controller = UIStoryboard.explore.instantiateInitialViewController()!
            
        case .planOverView: controller = UIStoryboard.planOverView.instantiateInitialViewController()!


        }

        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {
            
        case .explore:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.zoomIn),
                selectedImage: UIImage.asset(.zoomOut)
            )
            
        case .planOverView:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.zoomIn),
                selectedImage: UIImage.asset(.zoomIn)
            )
        }
    }
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private let tabs: [Tab] = [.explore, .planOverView]
    
    var trolleyTabBarItem: UITabBarItem!
    
    var orderObserver: NSKeyValueObservation!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })

        trolleyTabBarItem = viewControllers?[0].tabBarItem
        
        trolleyTabBarItem.badgeColor = .brown

        delegate = self
    }

    // MARK: - UITabBarControllerDelegate

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {


        return true
    }
}
