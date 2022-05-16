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
            userImage.loadImage(data[index].imageUrl, placeHolder: UIImage.asset(.imagePlaceholder))
        }
    }
    

    

    
    
    func setupContainerView() {
        containerView.stickSafeArea(containerView, self)
    }
    
    func setUpImage() {
        userImage.stickView(userImage, containerView)
        userImage.backgroundColor = .systemOrange
        userImage.layer.masksToBounds = true

    }
}
