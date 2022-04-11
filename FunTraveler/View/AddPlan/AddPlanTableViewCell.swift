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
    
    weak var delegate: AddPlanTableViewCellDelegate?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var departurePickerVIew: DatePickerView!
    
    @IBOutlet weak var backPickerVIew: DatePickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
   
}

extension AddPlanTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let title = textField.text else { return }
        
        delegate?.didChangeTitleData(self, text: title)
        
    }
}
