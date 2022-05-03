//
//  HeaderView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        contentView.backgroundColor = UIColor(patternImage: UIImage.asset(.headerBackgroundImage)!)
        //        contentView.contentMode = .scaleToFill
        let margins = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
//        contentView.layer.borderColor = UIColor.themeApricotDeep?.cgColor
//        contentView.layer.borderWidth = 4
//        contentView.layer.cornerRadius = 10.0
//        contentView.layer.masksToBounds = true
//        contentView.backgroundColor = .themeApricotDeep
       
        
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        // -------改不動-------//
        titleLabel.text = "123"
        titleLabel.tintColor = UIColor.themeApricotDeep
        // -------改不動-------//
        setupHeaderView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHeaderView()
    }

    private func setupHeaderView() {
//        contentView.backgroundColor = UIColor(patternImage: UIImage.asset(.headerBackgroundImage)!)
//        contentView.contentMode = .scaleToFill

    }

}
