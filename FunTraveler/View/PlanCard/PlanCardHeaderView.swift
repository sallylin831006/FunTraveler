//
//  PlanCardHeaderView.swift
//  PlanningCardTest
//
//  Created by 林翊婷 on 2022/4/9.
//

import UIKit

class PlanCardHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var departmentPickerView: TimePickerView!
    
    @IBOutlet weak var selectionView: SelectionView!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    
        setupHeaderView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupHeaderView()
    }

    private func setupHeaderView() {
        contentView.backgroundColor = UIColor.themeApricotDeep

        contentView.layer.cornerRadius = 40
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    }
}
