//
//  PlanOverViewTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class ExploreOverViewTableViewCell: UITableViewCell {
    
    var heartClosure: ((_ cell: ExploreOverViewTableViewCell, _ isHeartTapped: Bool) -> Void)?
    var collectClosure: ((_ cell: ExploreOverViewTableViewCell, _ isCollected: Bool) -> Void)?

    @IBOutlet weak var planImageView: UIImageView!
    
    @IBOutlet weak var dayTitle: UILabel!
    
    @IBOutlet weak var tripTitle: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var collectButton: UIButton!
    
    @IBOutlet weak var heartButton: UIButton!
    
    @IBOutlet weak var infoLabel: NSLayoutConstraint!
    
    @IBOutlet weak var dateLabel: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        heartButton.addTarget(self, action: #selector(tapheartButton), for: .touchUpInside)
        collectButton.addTarget(self, action: #selector(tapcollectButton), for: .touchUpInside)
    }
    var isHeartTapped: Bool = false
    var isCollected: Bool = false

    @objc func tapheartButton(_ sender: UIButton) {
        isHeartTapped = !isHeartTapped
        sender.isSelected = !isHeartTapped
        heartClosure?(self, isHeartTapped)
    }
    
    @objc func tapcollectButton(_ sender: UIButton) {
        isCollected = !isCollected
        sender.isSelected = !isCollected
        collectClosure?(self, isCollected)
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
        
    }
    
}
