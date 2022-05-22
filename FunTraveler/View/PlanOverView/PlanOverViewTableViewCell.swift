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
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .themeApricot
        let margins = UIEdgeInsets(top: 15, left: 30, bottom: 5, right: 30)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.addShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
