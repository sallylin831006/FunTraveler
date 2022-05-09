//
//  AlertLoginView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/6.
//

import UIKit

class AlertLoginView: UIView {
    
    private let iconImage = UIImageView()

    let alertLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupIconImage()
    }
    
    private func setupIconImage() {
        iconImage.image = UIImage.asset(.defaultUserImage)
        addSubview(iconImage)
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        iconImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        iconImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        alertLabel.textAlignment = .center
        addSubview(alertLabel)
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 10).isActive = true
        alertLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        alertLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
    }
}
