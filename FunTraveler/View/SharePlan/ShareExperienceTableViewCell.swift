//
//  ShareExperienceTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/16.
//

import UIKit

class ShareExperienceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderLbael: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var tripTimeLabel: UILabel!
    
    @IBOutlet weak var tripImage: UIImageView!
    
    @IBOutlet weak var storiesTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
