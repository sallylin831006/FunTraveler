//
//  RegisterTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import UIKit

class RegisterTableViewCell: UITableViewCell {
    
    var registerClosure: ((_ cell: RegisterTableViewCell) -> Void)?

    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var passwordCheckTextfield: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerButton.addTarget(self, action: #selector(tapRegisterButton), for: .touchUpInside)
    }
    
    @objc func tapRegisterButton() {
        registerClosure?(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}