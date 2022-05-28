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
        self.backgroundConfiguration = nil
        self.backgroundColor = .themeApricot
        segementControl.setTitleTextAttributes([.foregroundColor: UIColor.themeApricotDeep ?? .white], for: .selected)
        segementControl.setTitleTextAttributes([.foregroundColor: UIColor.themeRed ?? .white], for: .normal)
        followbutton.layer.cornerRadius = CornerRadius.buttonCorner
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
