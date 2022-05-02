//
//  ButtonHelper.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/2.
//

import UIKit

private var buttonTouchEdgeInsets: UIEdgeInsets?

extension UIButton {
    var touchEdgeInsets: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &buttonTouchEdgeInsets) as? UIEdgeInsets
        }

        set {
            objc_setAssociatedObject(self,
                &buttonTouchEdgeInsets, newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var frame = self.bounds
        
        if let touchEdgeInsets = self.touchEdgeInsets {
            frame = frame.inset(by: touchEdgeInsets)
        }
        
        return frame.contains(point)
    }
}

enum CornerRadius {
    static let buttonCorner: CGFloat = 12
}
