//
//  PlanOverViewTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit


class ExploreOverViewTableViewCell: UITableViewCell {
    
    var friendClosure: (() -> Void)?
    var heartClosure: ((_ isLiked: Bool) -> Void)?
    var collectClosure: ((_ isCollected: Bool) -> Void)?
    var followClosure: ((_ cell: ExploreOverViewTableViewCell, _ isfollowed: Bool) -> Void)?

    @IBOutlet weak var planImageView: UIImageView!
    
    @IBOutlet weak var dayTitleLabel: UILabel!
    
    @IBOutlet weak var tripTitleLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var collectButton: UIButton!
    
    @IBOutlet weak var heartButton: UIButton!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var numberOfLikeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    private var isCollected: Bool = false
    
    private var isLiked: Bool = false

    func layoutCell(data: Explore) {
        
        heartButton.touchEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)

        dayTitleLabel.text = "\(data.days)天| 旅遊回憶"
        
        tripTitleLabel.text = data.title
        
        userNameLabel.text = data.user.name
        
        numberOfLikeLabel.text = "\(data.likeCount)個讚"
        
        if data.user.imageUrl == "" {
            userImageView.image = UIImage.asset(.defaultUserImage)
        } else {
            userImageView.loadImage(data.user.imageUrl)
        }
            
        collectButton.setImage(UIImage.asset(.collectedIconSelected), for: .selected)
        collectButton.setImage(UIImage.asset(.collectedIconNormal), for: .normal)
        self.isCollected = data.isCollected
        collectButton.isSelected = data.isCollected
        
        heartButton.setImage(UIImage.asset(.heartSelected), for: .selected)
        heartButton.setImage(UIImage.asset(.heartNormal), for: .normal)
        self.isLiked = data.isLiked
        heartButton.isSelected = data.isLiked

        followButton.setTitle("追蹤", for: .normal)
        followButton.setTitleColor(UIColor.themeApricotDeep, for: .normal)
        followButton.layer.borderColor = UIColor.themeApricotDeep?.cgColor
        
        dateLabel.text = data.publishedDate
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        heartButton.addTarget(self, action: #selector(tapHeartButton), for: .touchUpInside)
        collectButton.addTarget(self, action: #selector(tapCollectButton), for: .touchUpInside)
        followButton.addTarget(self, action: #selector(tapFollowButton), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedUserImage(gestureRecognizer:)))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(gesture)
        
        let nameGesture = UITapGestureRecognizer(target: self, action: #selector(tappedUserName(gestureRecognizer:)))
        userNameLabel.isUserInteractionEnabled = true
        userNameLabel.addGestureRecognizer(nameGesture)
        
    }
    
    @objc func tappedUserImage(gestureRecognizer: UITapGestureRecognizer) {
        friendClosure?()
    }
    
    @objc func tappedUserName(gestureRecognizer: UITapGestureRecognizer) {
        friendClosure?()
    }
   
    var isfollowed: Bool = false
    
    @objc func tapHeartButton(_ sender: UIButton) {
        sender.isSelected = !isLiked
        heartClosure?(!isLiked)
    }
    
    @objc func tapCollectButton(_ sender: UIButton) {
        sender.isSelected = !isCollected
        collectClosure?(!isCollected)
    }
    
    @objc func tapFollowButton(_ sender: UIButton) {
        sender.isSelected = !isfollowed
        isfollowed = !isfollowed
        followClosure?(self, isfollowed)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .themeApricot
        let margins = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 8
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        
        planImageView.backgroundColor = UIColor.themeApricotDeep
        
        userImageView.layer.cornerRadius = userImageView.frame.width/2
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
}
