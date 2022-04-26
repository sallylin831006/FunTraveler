//
//  ProfileTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/26.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.borderColor = UIColor.themeApricotDeep?.cgColor
        contentView.layer.borderWidth = 4
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .themeApricotDeep
        userImageView.backgroundColor = UIColor.white
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }
    
}
