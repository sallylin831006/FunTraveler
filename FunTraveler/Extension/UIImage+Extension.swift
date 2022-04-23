//
//  UIImage+Extension.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/9.
//

import Foundation
import UIKit
import SwiftUI

enum ImageAsset: String {

    // Planning Page
    case orderMarker
    case zoomIn
    case zoomOut
    
    case headerBackgroundImage
    
    // Tabs
    case exploreSelected
    case exploreNormal
    
    case tripSelected
    case tripNormal
    
    case collectSelected
    case collectNormal
    
    case profileSelected
    case profileNormal
    
    case cameraSelected

}

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}
