//
//  VideoWallHeaderView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/18.
//

import UIKit

class VideoWallHeaderView: UICollectionReusableView {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = 45/2
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        
    }
    
    func layoutHeaderView(data: [Video], section: Int) {
        userImageView.loadImage(data[section].user.imageUrl)
        userNameLabel.text =  data[section].user.name
    }
    
}
