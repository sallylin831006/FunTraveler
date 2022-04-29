//
//  CommentFooterView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/26.
//

import UIKit

class CommentFooterView: UITableViewHeaderFooterView {
    
    var sendCommentClosure: (() -> Void)?


    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var sendCommentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupFooterView()
    }

    private func setupFooterView() {
        
    }
    
    func layoutFooter() {
        
    }

}
