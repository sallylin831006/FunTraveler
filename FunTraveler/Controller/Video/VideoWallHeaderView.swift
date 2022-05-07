//
//  VideoWallHeaderView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/18.
//

import UIKit

protocol VideoWallHeaderViewDelegate: AnyObject {
    func tapToFollow(_ followButton: UIButton, _ section: Int)
    
    func tapToUserProfile(_ section: Int)
    
    func blockUser(_ blockButton: UIButton, _ index: Int)
}

class VideoWallHeaderView: UICollectionReusableView {
    
    weak var delegate: VideoWallHeaderViewDelegate?
    var section: Int = 0
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var blockButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.width/2
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        followButton.layer.cornerRadius = CornerRadius.buttonCorner
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedUserImage(gestureRecognizer:)))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(gesture)
        
        let nameGesture = UITapGestureRecognizer(target: self, action: #selector(tappedUserName(gestureRecognizer:)))
        userNameLabel.isUserInteractionEnabled = true
        userNameLabel.addGestureRecognizer(nameGesture)
        
        blockButton.addTarget(self, action: #selector(tapBlockButton), for: .touchUpInside)
    
    }
    
    func layoutHeaderView(data: [Video], section: Int) {
        self.section = section
        
        if data[section].user.imageUrl == "" {
            userImageView.image = UIImage.asset(.defaultUserImage)
        } else {
            userImageView.loadImage(data[section].user.imageUrl, placeHolder: UIImage.asset(.imagePlaceholder))
        }
        
        userNameLabel.text =  data[section].user.name
        
        followButton.addTarget(self, action: #selector(tapFollowButton), for: .touchUpInside)
        
        let isFriend = data[section].user.isFriend
        let isInvite = data[section].user.isInvite
        guard let userId = KeyChainManager.shared.userId else { return }
        
        
        if !isFriend && Int(userId) == data[section].user.id {
            followButton.isHidden = true
            blockButton.isHidden = true
            return
        } else if isFriend {
            followButton.isHidden = false
            followButton.setTitle("已追蹤", for: .normal)
            followButton.backgroundColor = .themePink
            followButton.isUserInteractionEnabled = false
        } else if !isFriend && isInvite {
            followButton.isHidden = false
            followButton.setTitle("已送出邀請", for: .normal)
            followButton.backgroundColor = .themePink
            followButton.isUserInteractionEnabled = false
        } else if !isFriend && !isInvite {
            followButton.isHidden = false
            followButton.backgroundColor = .themeRed
            followButton.setTitle("追蹤", for: .normal)
            followButton.addTarget(self, action: #selector(tapFollowButton), for: .touchUpInside)
        }

    }
    
    @objc func tapFollowButton(_ sender: UIButton) {
        delegate?.tapToFollow(sender, section)
    }
    
    @objc func tappedUserImage(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.tapToUserProfile(section)
    }
    
    @objc func tappedUserName(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.tapToUserProfile(section)
    }
    
    @objc func tapBlockButton(_ sender: UIButton, _ index: Int) {
        delegate?.blockUser(sender, section)
    }
 
}
