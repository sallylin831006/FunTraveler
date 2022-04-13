//
//  PlanCardTableViewCell.swift
//  PlanningCardTest
//
//  Created by 林翊婷 on 2022/4/6.
//

import UIKit
class PlanCardTableViewCell: UITableViewCell {

    var durationTime: Double = 1

    var times = ["1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5"]
    
    var durationTime: Double = 1 {
        didSet {
            timePickerView.timeTextField.text = "\(durationTime)小時"
            calculateTime()
        }
    }

    private var times = ["1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5"]
    

    @IBOutlet weak var timePickerView: TimePickerView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var orderLabel: UIImageView!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calculateTime()
        
        timePickerView.picker.delegate = self
        
        timePickerView.picker.dataSource = self

        timePickerView.delegate = self
        
        startTimeLabel.text = startTime

        timePickerView.timeTextField.text = "\(durationTime)小時"
    }
    
    func calculateTime() {
        
        do {
            let date = try TimeManager.getDateFromString(
                dateFormat: "HH:mm", dateString: startTime, duration:
                    durationTime)
            let formatMinutes = String(format: "%02d", date.endMinutes)
            endTimeLabel.text = "\(date.endHours):\(formatMinutes)"
            
        } catch let wrongError {
            print("Error message: \(wrongError),Please add correct time!")
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension PlanCardTableViewCell: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(times[row])小時"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        durationTime = Double(times[row]) ?? 1.0
        self.timePickerView.timeTextField.text = "\(times[row])小時"
        
    }
}

extension PlanCardTableViewCell: TimePickerViewDelegate {
    func donePickerViewAction() {
        calculateTime()
    }
    
}
