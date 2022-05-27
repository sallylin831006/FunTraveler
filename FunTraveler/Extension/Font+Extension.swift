//
//  Font+Extension.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/1.
//

import UIKit

public extension UIFont {

    enum AppleColorEmoji: String {

        case colorEmoji = "AppleColorEmoji"

        public func font(size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size)!
        }
    }
}
