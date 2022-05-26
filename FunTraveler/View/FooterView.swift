//
//  FooterView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

protocol FooterViewDelegate: AnyObject {
    func saveButton(_ saveButton: UIButton)
    func cancelButton(_ saveButton: UIButton)
}

class FooterView: UITableViewHeaderFooterView {
    
    weak var delegate: FooterViewDelegate?

    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        saveButton.addTarget(target, action: #selector(tapSaveButton(_:)), for: .touchUpInside)
        
        cancelButton.addTarget(target, action: #selector(tapCancelButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapSaveButton(_ sender: UIButton) {
        delegate?.saveButton(sender)
    }
    
    @objc func tapCancelButton(_ sender: UIButton) {
        delegate?.cancelButton(sender)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        saveButton.layer.cornerRadius = CornerRadius.buttonCorner
        cancelButton.layer.cornerRadius = CornerRadius.buttonCorner
        self.backgroundConfiguration = nil
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
       
        setupFooterView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupFooterView()
    }

    private func setupFooterView() {
        
    }

}
