//
//  PlanOverViewTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class ExploreOverViewTableViewCell: UITableViewCell {
    
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
        
        dayTitleLabel.text = "\(data.days)天| 旅遊回憶"
        
        tripTitleLabel.text = data.title
        
        userNameLabel.text = data.user.name
        
        numberOfLikeLabel.text = "\(data.likeCount)個讚"
        
        if data.user.imageUrl == "" {
            userImageView.backgroundColor = .systemGray
        } else {
            userImageView.loadImage(data.user.imageUrl)
        }
            
        collectButton.setImage(UIImage.asset(.collectSelected), for: .selected)
        collectButton.setImage(UIImage.asset(.collectNormal), for: .normal)
        self.isCollected = data.isCollected
        collectButton.isSelected = data.isCollected
        
        heartButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        self.isLiked = data.isLiked
        heartButton.isSelected = data.isLiked

        followButton.setTitle("追蹤", for: .normal)
        followButton.setTitleColor(UIColor.themeApricotDeep, for: .normal)
        followButton.layer.borderColor = UIColor.themeApricotDeep?.cgColor
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        heartButton.addTarget(self, action: #selector(tapHeartButton), for: .touchUpInside)
        collectButton.addTarget(self, action: #selector(tapCollectButton), for: .touchUpInside)
        followButton.addTarget(self, action: #selector(tapFollowButton), for: .touchUpInside)
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
        
        let margins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.borderColor = UIColor.themeApricotDeep?.cgColor
        contentView.layer.borderWidth = 4
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        
        planImageView.backgroundColor = UIColor.themeApricotDeep
        
        userImageView.layer.cornerRadius = 40/2
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
}
