//
//  AddPlanTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class AddPlanTableViewCell: UITableViewCell {
    
    var titleClosure : ((_ text: String) -> Void)?

    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var departurePickerVIew: DatePickerView!
    
    @IBOutlet weak var backPickerVIew: DatePickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleClosure?(textField.text ?? "")
//        departurePickerVIew.dateClosure = { dateText in
//            print(dateText)
//        }
//        backPickerVIew.dateClosure = { dateText in
//            print(dateText)
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func passTitleData(tripTitle: String){
        textField.text = tripTitle
    }
    
    func layoutCell(tripTitle: String) {
        textField.text = tripTitle
        
    }
    
}
