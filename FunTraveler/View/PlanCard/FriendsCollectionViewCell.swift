//
//  PhotoCollectionViewCell.swift
//  TestSharePlan
//
//  Created by 林翊婷 on 2022/4/15.
//

import UIKit

class FriendsCollectionViewCell: UICollectionViewCell {
    
    var friendsClosure: ((_ cell: FriendsCollectionViewCell) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        friendsClosure?(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = UIColor.systemYellow
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 4
        contentView.layer.cornerRadius = contentView.frame.width/2
        contentView.layer.masksToBounds = true
        
    }

}
