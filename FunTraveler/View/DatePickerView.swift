//
//  DatePickerView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class DatePickerView: UIView {
    
    var dateClosure : ((_ text: String, _ date: Date) -> Void)?

    var datePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupSettingPickerView()
        
    }
}

extension DatePickerView {

    private func setupSettingPickerView() {
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100))
        
        datePicker.datePickerMode = .date

        datePicker.minuteInterval = 15
        datePicker.date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        datePicker.minimumDate = Date()
        datePicker.locale = Locale(identifier: "zh_TW")
        
        // ACTION
        datePicker.addTarget(self, action: #selector(tapToChangeDate), for: .valueChanged)
        addSubview(datePicker)
 
        layoutOfPicker()
        
    }
    
    @objc func tapToChangeDate(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        // formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.dateFormat = "yyyy-MM-dd"

        dateClosure?(formatter.string(from: datePicker.date), datePicker.date)
    }
    
    func layoutOfPicker() {
        datePicker.stickView(datePicker, self)
    }
    
}

extension Calendar {
    func numberOfTwoDays(_ from: Date, _ andto: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: andto)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day! + 1
    }
}
