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
        self.backgroundColor = .themeApricot
        segementControl.setTitleTextAttributes([.foregroundColor: UIColor.themeApricotDeep ?? .white], for: .selected)
        segementControl.setTitleTextAttributes([.foregroundColor: UIColor.themeRed ?? .white], for: .normal)
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
