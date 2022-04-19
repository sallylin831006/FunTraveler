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
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        let margins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        contentView.frame = contentView.frame.inset(by: margins)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.layer.borderColor = UIColor.themeApricotDeep?.cgColor
        contentView.layer.borderWidth = 4
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        
        planImageView.backgroundColor = UIColor.themeApricotDeep

    }
    
}
