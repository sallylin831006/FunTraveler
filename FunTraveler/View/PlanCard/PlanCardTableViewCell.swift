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
            trafficPickerView.timeTextField.text = "\(trafficTime)小時"
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
    
    private var trafficTimes = ["1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5"]
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
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

//            endTimeClosure?("\(date.endHours):\(formatMinutes)")
            
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
            return "\(trafficTimes[row])小時"
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            guard let selectedTimes = Double(times[row]) else { return }
            durationTime = selectedTimes
            self.timePickerView.timeTextField.text = "\(durationTime)小時"
            
        } else {
            guard let selectedTimes = Double(trafficTimes[row]) else { return }
            trafficTime = selectedTimes
            self.trafficPickerView.timeTextField.text = "\(trafficTimes)小時"
        }
        
    }
}

extension PlanCardTableViewCell: TimePickerViewDelegate {
    func donePickerViewAction() {
        calculateTime()
        delegate?.updateTime(startTime: startTime, duration: durationTime, trafficTime: trafficTime, index: index)
    }
    
}
