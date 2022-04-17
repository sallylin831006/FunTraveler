//
//  UIStoryboard+Extension.swift
//  TestPopup
//
//  Created by 林翊婷 on 2022/4/8.
//

import Foundation
import UIKit

struct StoryboardCategory {
    
    static let main = "Main"

    static let explore = "Explore"
    
    static let profile = "Profile"
    
    static let planOverView = "PlanOverView"

    static let planDetailVC = "PlanDetailViewController"
    
    static let planPickerVC = "PlanPickerViewController"
    
    static let addPlanVC = "AddPlanViewController"
    
    static let searchVC = "SearchViewController"
    
    static let shareVC = "SharePlanViewController"
    
    static let exploreDetailVC = "ExploreDetailViewController"
    
}

extension UIStoryboard {

    static var main: UIStoryboard { return stStoryboard(name: StoryboardCategory.main) }
    
    static var explore: UIStoryboard { return stStoryboard(name: StoryboardCategory.explore) }

    static var planOverView: UIStoryboard { return stStoryboard(name: StoryboardCategory.planOverView) }
    
    static var profile: UIStoryboard { return stStoryboard(name: StoryboardCategory.profile) }
    
    static var exploreDetailVC: UIStoryboard { return stStoryboard(name: StoryboardCategory.exploreDetailVC) }

    private static func stStoryboard(name: String) -> UIStoryboard {

        return UIStoryboard(name: name, bundle: nil)
    }
}
