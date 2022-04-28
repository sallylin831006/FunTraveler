//
//  SegementView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/28.
//

import UIKit

class SegementView: UITableViewHeaderFooterView {

    override func layoutSubviews() {
        super.layoutSubviews()
        //        contentView.backgroundColor = UIColor(patternImage: UIImage.asset(.headerBackgroundImage)!)
        //        contentView.contentMode = .scaleToFill
//        let margins = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
//        contentView.frame = contentView.frame.inset(by: margins)
//        contentView.layer.borderColor = UIColor.themeApricotDeep?.cgColor
//        contentView.layer.borderWidth = 4
//        contentView.layer.cornerRadius = 10.0
//        contentView.layer.masksToBounds = true
//        contentView.backgroundColor = .themeApricotDeep
       
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
      
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
