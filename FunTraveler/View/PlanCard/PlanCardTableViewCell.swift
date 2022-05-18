//
//  PlanCardTableViewCell.swift
//  PlanningCardTest
//
//  Created by 林翊婷 on 2022/4/6.
//

import UIKit

protocol PlanCardTableViewCellDelegate: AnyObject {
    
    func updateTime(startTime: String, duration: Double, trafficTime: Double, index: Int)

}

class PlanCardTableViewCell: UITableViewCell {
    
    var index: Int = 1
        
    weak var delegate: PlanCardTableViewCellDelegate?
    
    var trafficTime: Double = 1 {
        didSet {
            var showTrafficTime: String = ""
            if trafficTime < 60 {
                showTrafficTime = "\(Int(trafficTime))分鐘"
            } else if trafficTime > 60 {
                showTrafficTime = "\(Int(trafficTime)/60)小時\(Int(trafficTime) - Int(trafficTime/60)*60)分鐘"
            }
            trafficPickerView.timeTextField.text = showTrafficTime
            calculateTime()
        }
    }

    var durationTime: Double = 1 {
        didSet {
            timePickerView.timeTextField.text = "\(durationTime)小時"
            calculateTime()
        }
    }

    private var times = ["1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5"]
    private var trafficTimes = ["0.5","1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5"]

//    private var trafficTimes = ["30分鐘", "1小時", "1小時30分鐘", "2小時", "2小時30分鐘", "3小時", "3小時30分鐘", "4小時", "4小時30分鐘", "5小時", "5小時30分鐘", "6小時"]

    var startTime: String = "" {
        didSet {
            startTimeLabel.text = startTime
            calculateTime()
        }
}
    
//    var endTimeClosure : ((_ text: String) -> Void)?

    @IBOutlet weak var orderLabel: UILabel!
    
    @IBOutlet weak var timePickerView: TimePickerView!
    
    @IBOutlet weak var trafficPickerView: TimePickerView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var orderImage: UIImageView!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.cornerRadius = CornerRadius.buttonCorner
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.selectionStyle = .none
        trafficPickerView.picker.delegate = self
        
        trafficPickerView.picker.dataSource = self

        trafficPickerView.delegate = self
        
        trafficPickerView.picker.tag = 2
        
        timePickerView.picker.delegate = self
        
        timePickerView.picker.dataSource = self

        timePickerView.delegate = self
        
        timePickerView.picker.tag = 1
        
        startTimeLabel.text = startTime
    }
    
    func calculateTime() {
        
        do {
            let date = try TimeManager.getDateFromString(startTime: startTime, duration: durationTime)
            let formatMinutes = String(format: "%02d", date.endMinutes)
            endTimeLabel.text = "\(date.endHours):\(formatMinutes)"
        } catch let wrongError {
            print("Error message: \(wrongError),Please add correct time!")
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func layouCell(data: Schedule, index: Int) {
        nameLabel.text = data.name
        addressLabel.text = data.address
        startTime = data.startTime
        durationTime = data.duration
        orderLabel.text = String(index + 1)
    }

}

extension PlanCardTableViewCell: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return times.count
        } else {
            return trafficTimes.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return "\(times[row])小時"
        } else {
            return "\(trafficTimes[row])"
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            guard let selectedTimes = Double(times[row]) else { return }
            durationTime = selectedTimes
            self.timePickerView.timeTextField.text = "\(durationTime)小時"
            
        } else {
            let selectedTimes = trafficTimes[row]
            guard let selectedTime = Double(selectedTimes) else { return }
            trafficTime = selectedTime
            self.trafficPickerView.timeTextField.text = "\(trafficTime)"
        }
        
    }
}

extension PlanCardTableViewCell: TimePickerViewDelegate {
    
    func donePickerViewAction() {
        calculateTime()
        delegate?.updateTime(startTime: startTime, duration: durationTime, trafficTime: trafficTime, index: index)
    }
    
}
