//
//  TimePicker.swift
//  PickerViewForHours
//
//  Created by 林翊婷 on 2022/4/7.
//

import UIKit

protocol TimePickerViewDelegate: AnyObject {
    func donePickerViewAction()
}

class TimePickerView: UIView {
    
    weak var delegate: TimePickerViewDelegate?
    
    var picker = UIPickerView()
    let timeTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupTimePickerView()
    }
}

extension TimePickerView {
    
    private func setupTimePickerView() {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .themeLightBlue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(
            title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        timeTextField.font = UIFont.systemFont(ofSize: 12)
        timeTextField.backgroundColor = .themeApricotDeep
        timeTextField.inputView = picker
        timeTextField.inputAccessoryView = toolBar
        
        timeTextField.backgroundColor = UIColor.init(
            red: 0.9, green: 0.9, blue: 0.9, alpha: 0.4)
        
        timeTextField.layer.cornerRadius = 5
        
        timeTextField.textAlignment = .center
        
        layoutOfTimePickerView()
    }
    
    @objc func donePicker() {
        delegate?.donePickerViewAction()
        timeTextField.resignFirstResponder()
    }
    
    func layoutOfTimePickerView() {
        addSubview(timeTextField)
        timeTextField.translatesAutoresizingMaskIntoConstraints = false
        timeTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        timeTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        timeTextField.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        timeTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}
