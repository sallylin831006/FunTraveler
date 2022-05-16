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
        iconImage.centerViewWithSize(iconImage, self, width: 100, height: 100)
        
        alertLabel.textAlignment = .center
        addSubview(alertLabel)
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 10).isActive = true
        alertLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        alertLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
    }
}
