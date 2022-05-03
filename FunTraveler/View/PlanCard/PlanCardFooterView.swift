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
        scheduleButton.layer.cornerRadius = CornerRadius.buttonCorner
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        scheduleButton.backgroundColor = UIColor.themeRed

        setupFooterView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupFooterView()
    }

    private func setupFooterView() {
        contentView.backgroundColor = UIColor.clear

    }
    
}
