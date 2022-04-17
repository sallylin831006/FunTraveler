//
//  ExploreDetailTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/17.
//

import UIKit

class ExploreDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var tripImage: UIImageView!
    
    @IBOutlet weak var storiesTextLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
