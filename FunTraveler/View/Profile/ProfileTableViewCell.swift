//
//  ProfileTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/26.
//

import UIKit

protocol ProfileTableViewCellDelegate: AnyObject {
    
    func didChangeName( _ cell: ProfileTableViewCell, text: String)
}

class ProfileTableViewCell: UITableViewCell {
    
    weak var changeNameDelegate: ProfileTableViewCellDelegate?
    
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    

    @IBAction func tapFriendListButton(_ sender: Any) {
        
    }

    @IBOutlet weak var numberOfFriendsButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .themeApricot
        let margins = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.borderColor = UIColor.themeApricotDeep?.cgColor
        contentView.layer.borderWidth = 4
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .themeApricotDeep
        userImageView.backgroundColor = UIColor.white
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        editButton.isHidden = true
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        userNameTextField.addTarget(self, action: #selector(editUserNameTextField(_:)), for: .valueChanged)
        userNameTextField.delegate = self
        
        
//        let textFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapUserNameTextField(_:)))
//        userNameTextField.addGestureRecognizer(textFieldTapGesture)
//        userNameTextField.isUserInteractionEnabled = true

    }
    
    
    
    @objc func editUserNameTextField(_ textField: UITextField) {
        editButton.isHidden = false //NOT WORKING
        userNameTextField.isUserInteractionEnabled = true
        userNameTextField.addBottomBorder()
        
    }
    
//    @objc func tapUserNameTextField(_ gestureRecognizer: UITapGestureRecognizer) {
//        editButton.isHidden = false
//        userNameTextField.isUserInteractionEnabled = true
//        userNameTextField.addBottomBorder()
//
//        if gestureRecognizer.state == .failed {
//            editButton.isHidden = true
//            userNameTextField.isUserInteractionEnabled = false
//        }
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }
    
    func layoutCell(data: User) {
        userNameTextField.text = data.name
        if data.imageUrl == "" {
            userImageView.image = nil
        } else {
            userImageView.loadImage(data.imageUrl)
        }
    }
}

extension ProfileTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let name = textField.text else { return }
        
        changeNameDelegate?.didChangeName(self, text: name)
        
    }
}

extension UITextField {
    func addBottomBorder() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
