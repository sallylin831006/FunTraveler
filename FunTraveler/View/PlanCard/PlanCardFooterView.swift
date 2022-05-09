//
//  PlanCardFooterView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/10.
//

import UIKit

class PlanCardFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var scheduleButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundConfiguration = nil
        scheduleButton.layer.cornerRadius = CornerRadius.buttonCorner
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
//        contentView.backgroundColor = UIColor.clear
//        self.backgroundColor = UIColor.clear
    }
    
}
