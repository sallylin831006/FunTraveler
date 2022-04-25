//
//  UIView+Extension.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/24.
//

import UIKit

@IBDesignable
extension UIView {
    func layoutLoadingView(_ objectView: UIView, _ view: UIView) {

        objectView.removeFromSuperview()

        addSubview(objectView)
        objectView.translatesAutoresizingMaskIntoConstraints = false
        objectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        objectView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        objectView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }

}
