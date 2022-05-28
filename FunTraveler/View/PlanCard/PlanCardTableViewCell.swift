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
    
    weak var delegate: PlanCardTableViewCellDelegate?
    private var index: Int = 1
    
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
    
    private var durationTime: Double = 1 {
        didSet {
            timePickerView.timeTextField.text = "\(durationTime)小時"
            calculateTime()
        }
    }
    
    private var times = PickerConstant.scheduleTImes
    private var trafficTimes = PickerConstant.trafficTImes
    
    private var startTime: String = "" {
        didSet {
            startTimeLabel.text = startTime
            calculateTime()
        }
    }
    
    @IBOutlet weak private var orderLabel: UILabel!
    
    @IBOutlet weak private var timePickerView: TimePickerView!
    
    @IBOutlet weak private var trafficPickerView: TimePickerView!
    
    @IBOutlet weak private var nameLabel: UILabel!
    
    @IBOutlet weak private var addressLabel: UILabel!
    
    @IBOutlet weak private var startTimeLabel: UILabel!
    
    @IBOutlet weak private var orderImage: UIImageView!
    
    @IBOutlet weak private var endTimeLabel: UILabel!
    
    @IBOutlet weak private var cardView: UIView!
    
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
    
    private func calculateTime() {
        do {
            let date = try TimeManager.getDateFromString(startTime: startTime, duration: durationTime)
            let formatMinutes = String(format: "%02d", date.endMinutes)
            endTimeLabel.text = "\(date.endHours):\(formatMinutes)"
        } catch let wrongError {
            print("Error message: \(wrongError),Please add correct time!")
        }
    }
    
    func layouCell(data: Schedule, index: Int) {
        nameLabel.text = data.name
        addressLabel.text = data.address
        startTime = data.startTime
        durationTime = data.duration
        orderLabel.text = String(index + 1)
        self.index = index
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        self.selectionStyle = .none
        cardView.layer.cornerRadius = CornerRadius.buttonCorner
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
