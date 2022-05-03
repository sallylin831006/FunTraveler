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

        dateClosure?(formatter.string(from: datePicker.date))
    }
    
    func layoutOfPicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        
        datePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        
        datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true

        datePicker.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true

        datePicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}
