//
//  AuthTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import UIKit

class AuthTableViewCell: UITableViewCell {
    
    var loginClosure: ((_ cell: AuthTableViewCell) -> Void)?

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var moveToRegisterButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loginButton.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)

    }
    
    @objc func tapLoginButton() {
        loginClosure?(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layoutCell() {
        
    }
    
}
