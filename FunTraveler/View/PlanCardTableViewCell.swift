//
//  PlanCardTableViewCell.swift
//  PlanningCardTest
//
//  Created by 林翊婷 on 2022/4/6.
//

import UIKit
class PlanCardTableViewCell: UITableViewCell {

    var durationTime: String?

    var times = ["1", "1.5", "2", "2.5", "3", "3.5"]

    @IBOutlet weak var pickerView: TimePickerView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var orderLabel: UIImageView!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    func layoutCell(
        startTime: String
    ) {
        
        startTimeLabel.text = startTime
        
        do {
            let date = try TimeManager.getDateFromString(
                dateFormat: "HH:mm", dateString: startTime, duration:
                    Double(pickerView.timeTextField.text ?? "2.00") ?? 2.00)
            
            endTimeLabel.text = "\(date.endHours):\(date.endMinutes)"

        } catch let wrongError {
            print("Error message: \(wrongError),Please add correct time!")
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

