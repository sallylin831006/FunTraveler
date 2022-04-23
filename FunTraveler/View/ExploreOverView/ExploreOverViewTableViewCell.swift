//
//  PlanOverViewTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class ExploreOverViewTableViewCell: UITableViewCell {
    
    var heartClosure: ((_ cell: ExploreOverViewTableViewCell, _ isHeartTapped: Bool) -> Void)?
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
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    private var isCollected: Bool = false
    
    func layoutCell(days: Int, tripTitle: String, userName: String, isCollected: Bool) {
        
        dayTitleLabel.text = "\(days)天| 旅遊回憶"
        
        tripTitleLabel.text = tripTitle
        
        userNameLabel.text = userName
        
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        self.isCollected = isCollected
        
        if isCollected {
            collectButton.setImage(UIImage.asset(.collectSelected), for: .normal)
        } else {
            collectButton.setImage(UIImage.asset(.collectNormal), for: .normal)
        }
        
//        if isCollectedTapped && isCollected {
//            collectButton.setImage(UIImage.asset(.collectSelected), for: .selected)
//        }
//        if isCollectedTapped && !isCollected {
//            collectButton.setImage(UIImage.asset(.collectNormal), for: .selected)
//        }
     
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
    var isHeartTapped: Bool = false
    var isCollectedTapped: Bool = false
    var isfollowed: Bool = false
    
    @objc func tapHeartButton(_ sender: UIButton) {
        sender.isSelected = !isHeartTapped
        isHeartTapped = !isHeartTapped
        heartClosure?(self, isHeartTapped)
    }
    
    @objc func tapCollectButton(_ sender: UIButton) {
        sender.isSelected = !isCollectedTapped
        isCollectedTapped = !isCollectedTapped
        collectClosure?(isCollected)
    }
    
    @objc func tapFollowButton(_ sender: UIButton) {
        sender.isSelected = !isfollowed
        isfollowed = !isfollowed
        followClosure?(self, isfollowed)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.borderColor = UIColor.themeApricotDeep?.cgColor
        contentView.layer.borderWidth = 4
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        
        planImageView.backgroundColor = UIColor.themeApricotDeep
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
}
