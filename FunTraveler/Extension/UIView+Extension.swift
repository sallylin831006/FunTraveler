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
        objectView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func stickView(_ objectView: UIView, _ view: UIView) {

        objectView.removeFromSuperview()

        view.addSubview(objectView)
        objectView.translatesAutoresizingMaskIntoConstraints = false

        objectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        objectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        objectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        objectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func stickSafeArea(_ objectView: UIView, _ view: UIView) {

        objectView.removeFromSuperview()

        view.addSubview(objectView)
        objectView.translatesAutoresizingMaskIntoConstraints = false
        
        objectView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        objectView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        objectView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        objectView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
    }
    
    func centerViewWithSize(_ objectView: UIView, _ view: UIView, width: CGFloat, height: CGFloat, centerXconstant: CGFloat = 0, centerYconstant: CGFloat = 0) {

        objectView.removeFromSuperview()

        view.addSubview(objectView)
        objectView.translatesAutoresizingMaskIntoConstraints = false
        objectView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: centerXconstant).isActive = true
        objectView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: centerYconstant).isActive = true
        objectView.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        objectView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
    }
    
    func centerView(_ objectView: UIView, _ view: UIView) {

        objectView.removeFromSuperview()
        view.addSubview(objectView)
        objectView.translatesAutoresizingMaskIntoConstraints = false
        objectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        objectView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    func addShadow() {
        layer.masksToBounds = false
        layer.cornerRadius = CornerRadius.buttonCorner
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.systemBrown.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
    }

}
