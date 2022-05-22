//
//  AddPlanTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

protocol AddPlanTableViewCellDelegate: AnyObject {
    
    func didChangeTitleData( _ cell: AddPlanTableViewCell, text: String)
}

class AddPlanTableViewCell: UITableViewCell {
    
    weak var titleDelegate: AddPlanTableViewCellDelegate?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var departurePickerVIew: DatePickerView!
    
    @IBOutlet weak var backPickerVIew: DatePickerView!
    
    @IBOutlet weak var dayCalculateLabel: UILabel!
    
    private var startDate: String?
    private var endDate: String?
    private var firstDate = Date()
    private var secondDate = Date()
    private var dayCalculateNum: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .themeApricot
        textField.addtextfieldBorder(textField: textField)

        textField.delegate = self
        
        
        departurePickerVIew.dateClosure = { [weak self] startDate, calaulateDate in
            self?.startDate = startDate
            self?.firstDate = calaulateDate
            let calendar = Calendar.current
            guard let secondDate = self?.secondDate else { return }
            let date1 = calendar.startOfDay(for: calaulateDate)
            let date2 = calendar.startOfDay(for: secondDate)
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            self?.dayCalculateNum = components.day ?? 0
        }
        
        
        backPickerVIew.dateClosure = { [weak self] endDate, calaulateDate in
            self?.endDate =  endDate
            self?.secondDate =  calaulateDate
            let calendar = Calendar.current
            guard let firstDate = self?.firstDate else { return }
            let date1 = calendar.startOfDay(for: firstDate)
            let date2 = calendar.startOfDay(for: calaulateDate)
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            self?.dayCalculateNum = components.day ?? 0
        }
        if dayCalculateNum <= -1 {
            dayCalculateLabel.text = ""
        } else {
            dayCalculateLabel.text = "共 \(dayCalculateNum+1) 天"
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
   
}

extension AddPlanTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let title = textField.text else { return }
        
        titleDelegate?.didChangeTitleData(self, text: title)
        
    }
}
