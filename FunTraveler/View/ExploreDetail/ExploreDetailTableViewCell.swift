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
    
    @IBOutlet weak var imageWithConstraint: NSLayoutConstraint!
    
    func layoutCell(data: Schedule, index: Int) {
        orderLabel.text = String(index + 1)
        nameLabel.text = data.name
        addressLabel.text = data.address
        durationLabel.text = "停留時間：\(data.duration)"
        
        if data.images.isEmpty {
            imageWithConstraint.constant = 0
//            tripImage.image = UIImage.asset(.imagePlaceholder)
            tripImage.backgroundColor = UIColor.themeApricotDeep
        } else {
            tripImage.loadImage(data.images.first, placeHolder: UIImage.asset(.imagePlaceholder))
            tripImage.contentMode = .scaleAspectFill
        }
        
        if data.description.isEmpty {
            storiesTextLabel.text = nil
        } else {
            storiesTextLabel.text = data.description
        }
        
    }
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        super.awakeFromNib()
        self.backgroundColor = .themeApricot
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
