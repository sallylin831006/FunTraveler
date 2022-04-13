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
    
    var searchDataClosure: ((_ cell: SearchTableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addToPlanButton(_ sender: UIButton) {
        searchDataClosure?(self)

    }
    
}
