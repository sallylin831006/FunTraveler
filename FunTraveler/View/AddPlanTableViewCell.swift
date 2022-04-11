//
//  AddPlanTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class AddPlanTableViewCell: UITableViewCell {
    @IBOutlet weak var departurePickerVIew: DatePickerView!
    
    @IBOutlet weak var backPickerVIew: DatePickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
