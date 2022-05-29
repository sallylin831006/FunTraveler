//
//  PlanOverViewTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

protocol ExploreOverViewTableViewCellDelegate: AnyObject {
    func passingfriendsData(_ index: Int)
    func passingHeartData(_ isLiked: Bool, _ index: Int)
    func passingCollectData(_ isCollected: Bool, _ index: Int)
}

class ExploreOverViewTableViewCell: UITableViewCell {
    
    weak var delegate: ExploreOverViewTableViewCellDelegate?
    
    var friendClosure: (() -> Void)?
    var heartClosure: ((_ isLiked: Bool) -> Void)?
    var collectClosure: ((_ isCollected: Bool) -> Void)?
    var followClosure: ((_ cell: ExploreOverViewTableViewCell, _ isfollowed: Bool) -> Void)?
    
    @IBOutlet private weak var planImageView: UIImageView!
    
    @IBOutlet private weak var dayTitleLabel: UILabel!
    
    @IBOutlet private weak var tripTitleLabel: UILabel!
    
    @IBOutlet private weak var userImageView: UIImageView!
    
    @IBOutlet private weak var userNameLabel: UILabel!
    
    @IBOutlet weak var collectButton: UIButton!
    
    @IBOutlet weak var heartButton: UIButton!
    
    @IBOutlet private weak var numberOfLikeLabel: UILabel!
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet private weak var lockIconImage: UIImageView!
    
    private var isCollected: Bool = false
    
    private var isLiked: Bool = false
    
    private var index: Int = 0
    
    func layoutCell(data: Explore, index: Int) {
        
        self.index = index
        
        if KeyChainManager.shared.token == nil {
            collectButton.isHidden = true
        } else {
            collectButton.isHidden = false
        }
        
        heartButton.touchEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
        
        dayTitleLabel.text = "\(data.days)天| 旅遊回憶"
        
        tripTitleLabel.text = data.title
        
        userNameLabel.text = data.user.name
        
        numberOfLikeLabel.text = "\(data.likeCount)個讚"
        
        if data.user.imageUrl == "" {
            userImageView.image = UIImage.asset(.defaultUserImage)
        } else {
            userImageView.loadImage(data.user.imageUrl, placeHolder: UIImage.asset(.imagePlaceholder))
        }
        
        collectButton.setImage(UIImage.asset(.collectedIconSelected), for: .selected)
        collectButton.setImage(UIImage.asset(.collectedIconNormal), for: .normal)
        self.isCollected = data.isCollected
        collectButton.isSelected = data.isCollected
        
        heartButton.setImage(UIImage.asset(.heartSelected), for: .selected)
        heartButton.setImage(UIImage.asset(.heartNormal), for: .normal)
        self.isLiked = data.isLiked
        heartButton.isSelected = data.isLiked
        
        dateLabel.text = data.publishedDate
        
        if data.isPrivate {
            lockIconImage.isHidden = false
        } else {
            lockIconImage.isHidden = true
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        heartButton.addTarget(self, action: #selector(tapHeartButton), for: .touchUpInside)
        collectButton.addTarget(self, action: #selector(tapCollectButton), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedUserImage(gestureRecognizer:)))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(gesture)
        
        let nameGesture = UITapGestureRecognizer(target: self, action: #selector(tappedUserName(gestureRecognizer:)))
        userNameLabel.isUserInteractionEnabled = true
        userNameLabel.addGestureRecognizer(nameGesture)
        
    }
    
    @objc func tappedUserImage(gestureRecognizer: UITapGestureRecognizer) {
        friendClosure?()
        delegate?.passingfriendsData(index)
    }
    
    @objc func tappedUserName(gestureRecognizer: UITapGestureRecognizer) {
        friendClosure?()
        delegate?.passingfriendsData(index)
    }
    
    var isfollowed: Bool = false
    
    @objc func tapHeartButton(_ sender: UIButton) {
        sender.isSelected = !isLiked
        heartClosure?(!isLiked)
        delegate?.passingHeartData(!isLiked, index)
    }
    
    @objc func tapCollectButton(_ sender: UIButton) {
        sender.isSelected = !isCollected
        collectClosure?(!isCollected)
        delegate?.passingCollectData(!isCollected, index)
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
