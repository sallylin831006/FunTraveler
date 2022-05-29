//
//  UnFollowTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/28.
//

import UIKit

class UnFollowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBAction func tapFollowButton(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .themeApricot
    }
    
}
