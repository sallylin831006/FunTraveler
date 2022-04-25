//
//  UIColor+Extension.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//
import UIKit

private enum STColor: String {

    case themeApricotDeep
    case themeRed
    case themeLightBlue
    
}

extension UIColor {

    static let themeApricotDeep = STColor(.themeApricotDeep)
    
    static let themeRed = STColor(.themeRed)
    
    static let themeLightBlue = STColor(.themeLightBlue)

    private static func STColor(_ color: STColor) -> UIColor? {

        return UIColor(named: color.rawValue)
    }

    static func hexStringToUIColor(hex: String) -> UIColor {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
