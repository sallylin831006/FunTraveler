//
//  DatePickerView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class DatePickerView: UIView {
    
    var dateClosure : ((_ text: String) -> Void)?

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
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 15
        datePicker.date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let fromDateTime = formatter.date(from: "2016-01-02 18:08")
        datePicker.minimumDate = fromDateTime
        let endDateTime = formatter.date(from: "2020-04-06 10:45")
        datePicker.maximumDate = endDateTime
        datePicker.locale = Locale(identifier: "zh_TW")
        
        // ACTION
        datePicker.addTarget(self, action: #selector(tapToChangeDate), for: .valueChanged)
        addSubview(datePicker)
 
        layoutOfPicker()
    }
    
    @objc func tapToChangeDate(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        dateClosure?(formatter.string(from: datePicker.date))
    }
    

    func layoutOfPicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        datePicker.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true

        datePicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}

