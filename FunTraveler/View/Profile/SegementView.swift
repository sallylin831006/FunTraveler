//
//  SegementView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/28.
//

import UIKit



class SegementView: UITableViewHeaderFooterView {
    
    var collectedClosure: (() -> Void)?
    
    
    @IBOutlet weak var followbutton: UIButton!
    

    @IBOutlet weak var segementControl: UISegmentedControl!

    @IBAction func tapSegementControll(_ sender: Any) {
        
        if segementControl.selectedSegmentIndex == 0 {
            print("我點了旅遊回憶")
        } else if segementControl.selectedSegmentIndex == 1 {
            print("我點了收藏")
            collectedClosure?()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        segementControl.setTitleTextAttributes([.foregroundColor: UIColor.themeApricotDeep ?? .white], for: .selected)
        segementControl.setTitleTextAttributes([.foregroundColor: UIColor.themeRed ?? .white], for: .normal)
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
