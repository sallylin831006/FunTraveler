//
//  PlanCardFooterView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/10.
//

import UIKit

protocol PlanCardFooterViewDelegate: AnyObject {
    func tapScheduleButton()
}

class PlanCardFooterView: UITableViewHeaderFooterView {
    
    weak var delegate: PlanCardFooterViewDelegate?
    
    @IBOutlet weak private var scheduleButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundConfiguration = nil
        scheduleButton.layer.cornerRadius = CornerRadius.buttonCorner
        self.backgroundConfiguration = nil
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scheduleButton.setTitle("+建立行程規劃", for: .normal)
        
        scheduleButton.addTarget(target, action: #selector(tapScheduleButton), for: .touchUpInside)
    }
    
    @objc func tapScheduleButton() {
        delegate?.tapScheduleButton()
    }
    
}
