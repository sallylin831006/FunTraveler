//
//  UIColor+Extension.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//
import UIKit

private enum STColor: String {

    case themeApricotDeep
    case themeApricot
    case themeRed
    case themePink
    case themeLightBlue
    
}

extension UIColor {

    static let themeApricotDeep = STColor(.themeApricotDeep)
    
    static let themeApricot = STColor(.themeApricot)
    
    static let themeRed = STColor(.themeRed)
    
    static let themePink = STColor(.themePink)
    
    static let themeLightBlue = STColor(.themeLightBlue)

    private static func STColor(_ color: STColor) -> UIColor? {

        return UIColor(named: color.rawValue)
    }

}
