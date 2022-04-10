//
//  PlanCardTableViewCell.swift
//  PlanningCardTest
//
//  Created by 林翊婷 on 2022/4/6.
//

import UIKit
class PlanCardTableViewCell: UITableViewCell {

    @IBOutlet weak var pickerView: TimePickerView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var orderLabel: UIImageView!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

