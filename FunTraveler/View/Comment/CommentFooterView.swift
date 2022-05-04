//
//  CommentFooterView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/26.
//

import UIKit

class CommentFooterView: UITableViewHeaderFooterView {
    
    var sendCommentClosure: (() -> Void)?
    var moveToLoginClosure: (() -> Void)?


    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var sendCommentButton: UIButton!
    
    @IBOutlet weak var moveToLoginButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        moveToLoginButton.addTarget(self, action: #selector(moveToLogin), for: .touchUpInside)
        sendCommentButton.addTarget(self, action: #selector(tapToSendComment), for: .touchUpInside)
        commentTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        sendCommentButton.isHidden = true
        self.backgroundColor = .themeApricot
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupFooterView()
        
    }
    
    @objc func tapToSendComment() {
        sendCommentClosure?()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        sendCommentButton.isHidden = false
    }
    
    @objc func moveToLogin() {
        
        moveToLoginClosure?()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupFooterView()
    }

    private func setupFooterView() {
        
    }
    
    func layoutFooter(data: Profile) {
        userImageView.loadImage(data.imageUrl, placeHolder: UIImage.asset(.imagePlaceholder))
        commentTextField.placeholder =  "以\(data.name)新增留言..."
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.width/2
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        
    }

}
