//
//  FooterView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class FooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        saveButton.layer.cornerRadius = CornerRadius.buttonCorner
        cancelButton.layer.cornerRadius = CornerRadius.buttonCorner
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
