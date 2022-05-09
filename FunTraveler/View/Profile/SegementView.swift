//
//  SegementView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/28.
//

import UIKit

protocol SegementViewDelegate: AnyObject {
    func switchSegement(_ segmentedControl: UISegmentedControl)
}

class SegementView: UITableViewHeaderFooterView {
    
    weak var delegate: SegementViewDelegate?
        
    @IBOutlet weak var followbutton: UIButton!
    
    @IBOutlet weak var segementControl: UISegmentedControl!
    
    @IBAction func tapSegementControll(_ sender: UISegmentedControl) {
        
        if segementControl.selectedSegmentIndex == 0 {
            self.delegate?.switchSegement(sender)
        } else if segementControl.selectedSegmentIndex == 1 {
            self.delegate?.switchSegement(sender)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        contentView.frame = contentView.frame.inset(by: margins)
        self.backgroundConfiguration = nil
        self.backgroundColor = .themeApricot
        segementControl.setTitleTextAttributes([.foregroundColor: UIColor.themeApricotDeep ?? .white], for: .selected)
        segementControl.setTitleTextAttributes([.foregroundColor: UIColor.themeRed ?? .white], for: .normal)
        followbutton.layer.cornerRadius = CornerRadius.buttonCorner
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
