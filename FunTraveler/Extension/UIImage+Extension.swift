//
//  UIImage+Extension.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/9.
//

import Foundation
import UIKit

enum ImageAsset: String {

    // Planning Page
    case orderMarker
    case zoomIn
    case zoomOut
    
    case headerBackgroundImage

}

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}
