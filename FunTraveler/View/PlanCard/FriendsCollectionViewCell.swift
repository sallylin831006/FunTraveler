//
//  PhotoCollectionViewCell.swift
//  TestSharePlan
//
//  Created by 林翊婷 on 2022/4/15.
//

import UIKit

class FriendsCollectionViewCell: UICollectionViewCell {
    
    let containerView = UIView()
    let userImage = UIImageView()
    
    var friendsClosure: ((_ cell: FriendsCollectionViewCell) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        friendsClosure?(self)
        setupContainerView()
        setUpImage()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .clear
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.borderWidth = 2
        containerView.layer.cornerRadius = contentView.frame.width/2
        containerView.layer.masksToBounds = true
        
        userImage.layer.cornerRadius = userImage.frame.width/2
        userImage.contentMode = .scaleAspectFill
    }
    
    func layoutCell(data: [User], index: Int) {
        
        if data[index].imageUrl == "" {
            userImage.image = UIImage.asset(.defaultUserImage)
        } else {
            userImage.loadImage(data[index].imageUrl)
        }
    }
    

    

    
    
    func setupContainerView() {
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        containerView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true

    }
    
    func setUpImage() {
        containerView.addSubview(userImage)
        userImage.backgroundColor = .systemOrange
        userImage.layer.masksToBounds = true
        userImage.translatesAutoresizingMaskIntoConstraints = false

        userImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        userImage.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        userImage.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        userImage.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true

    }
}
