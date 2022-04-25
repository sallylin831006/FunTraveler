//
//  SearchTableViewCell.swift
//  GoogleMapAPI
//
//  Created by 林翊婷 on 2022/4/9.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    var searchData = [Results]()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var actionBtn: UIButton!
    
    var searchDataClosure: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .themeApricotDeep
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        searchDataClosure?()

        // Configure the view for the selected state
    }
    
}
