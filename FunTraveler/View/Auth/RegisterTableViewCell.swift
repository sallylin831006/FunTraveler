//
//  RegisterTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import UIKit

class RegisterTableViewCell: UITableViewCell {
    
    var registerClosure: ((_ cell: RegisterTableViewCell) -> Void)?
    
    var cancelRegisterClosure: (() -> Void)?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var passwordCheckTextfield: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var cancelRegisterButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerButton.addTarget(self, action: #selector(tapRegisterButton), for: .touchUpInside)
        self.backgroundColor = .themeApricot
        cancelRegisterButton.addTarget(self, action: #selector(tapCancelRegisterButton), for: .touchUpInside)
        passwordTextfield.isSecureTextEntry = true
        passwordCheckTextfield.isSecureTextEntry = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        registerButton.layer.cornerRadius = CornerRadius.buttonCorner
        cancelRegisterButton.layer.cornerRadius = CornerRadius.buttonCorner
        
        nameTextField.addBottomBorder(textField: nameTextField)
        emailTextField.addBottomBorder(textField: emailTextField)
        passwordTextfield.addBottomBorder(textField: passwordTextfield)
        passwordCheckTextfield.addBottomBorder(textField: passwordCheckTextfield)
        
        emailTextField.keyboardType = .emailAddress
    }
    
    @objc func tapRegisterButton() {
        registerClosure?(self)
    }
    
    @objc func tapCancelRegisterButton() {
        cancelRegisterClosure?()
    }
    
}
