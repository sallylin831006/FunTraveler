//
//  TextfieldHelper.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/3.
//

import UIKit

enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone
    case pad
}

extension UITextField {
//
//    func addBottomBorder(textField: UITextField) {
//    }
//
//    func addtextfieldBorder(textField: UITextField) {
//    }

    func addBottomBorder(textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: -40, y: textField.frame.size.height - 1, width: textField.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.systemBrown.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    
    func addtextfieldBorder(textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.size.height - 1, width: textField.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.systemBrown.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
