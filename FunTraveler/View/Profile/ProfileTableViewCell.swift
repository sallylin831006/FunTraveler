//
//  ProfileTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/26.
//

import UIKit

protocol ProfileTableViewCellDelegate: AnyObject {
    
    func didChangeName( _ cell: ProfileTableViewCell, text: String)
    
    func blockUser(_ blockButton: UIButton)

}

class ProfileTableViewCell: UITableViewCell {
    
    weak var delegate: ProfileTableViewCellDelegate?
    
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    @IBOutlet weak var numberOfFriendLabel: UILabel!
    
    @IBOutlet weak var numberOfTrips: UILabel!
    
    @IBOutlet weak var numberOfFriendsButton: UIButton!
    
    @IBOutlet weak var blockButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundConfiguration = nil
        self.backgroundColor = .themeApricot
        let margins = UIEdgeInsets(top: 20, left: 30, bottom: -20, right: 30)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.backgroundColor = .themeApricot
        contentView.addShadow()
        userImageView.backgroundColor = UIColor.white
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = CornerRadius.buttonCorner
        userImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userNameTextField.delegate = self
        blockButton.addTarget(self, action: #selector(tapBlockButton(_:)), for: .touchUpInside)
        self.selectionStyle = .none
        
//        let textFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapUserNameTextField(_:)))
//        userNameTextField.addGestureRecognizer(textFieldTapGesture)
//        userNameTextField.isUserInteractionEnabled = true

    }
    
    
    @objc func editUserNameTextField(_ textField: UITextField) {
        userNameTextField.isUserInteractionEnabled = true
//        userNameTextField.addBottomBorder()
        
    }
    
    @objc func tapBlockButton(_ sender: UIButton) {
        delegate?.blockUser(sender)
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
    
    func layoutCell(data: Profile, isMyProfile: Bool) {
        
        
        userNameTextField.text = data.name
        if data.imageUrl == "" {
            userImageView.image = UIImage.asset(.defaultUserImage)
        } else {
            userImageView.loadImage(data.imageUrl, placeHolder: UIImage.asset(.imagePlaceholder))
        }
        numberOfFriendLabel.text = String(data.numberOfFriends)
        numberOfTrips.text = String(data.numberOfTrips)
        
        if isMyProfile {
            blockButton.isHidden = true
            userNameTextField.addTarget(self, action: #selector(editUserNameTextField(_:)), for: .valueChanged)
        } else {
            userNameTextField.isUserInteractionEnabled = false
            settingButton.isHidden = true
        }
    }
}

extension ProfileTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let name = textField.text else { return }
        
        delegate?.didChangeName(self, text: name)
        
    }
}
