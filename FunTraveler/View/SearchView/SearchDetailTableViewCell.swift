//
//  SearchDetailTableViewCell.swift
//  GoogleMapAPI
//
//  Created by 林翊婷 on 2022/4/10.
//

import UIKit

class SearchDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var bussinessStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .themeApricot
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
