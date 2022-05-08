//
//  PlanOverViewTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class PlanOverViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var planImageView: UIImageView!
    
    @IBOutlet weak var dayTitle: UILabel!
    
    @IBOutlet weak var tripTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .themeApricot
        let margins = UIEdgeInsets(top: 15, left: 30, bottom: 5, right: 30)
        contentView.frame = contentView.frame.inset(by: margins)
//        contentView.layer.borderColor = UIColor.white.cgColor
//        contentView.layer.borderWidth = 6
//        contentView.layer.cornerRadius = 10.0
//        contentView.layer.masksToBounds = true
        contentView.addShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

extension UIView {
    func addShadow() {
        layer.masksToBounds = false
        layer.cornerRadius = CornerRadius.buttonCorner
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.systemBrown.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}
