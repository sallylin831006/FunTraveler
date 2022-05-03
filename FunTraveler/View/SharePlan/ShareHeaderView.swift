//
//  ShareHeaderView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/19.
//

import UIKit

class ShareHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var selectionView: SegmentControlView!
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    
        setupHeaderView()
        titleLabel.text = "行程分享"

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupHeaderView()
    }

    private func setupHeaderView() {
//        contentView.backgroundColor = UIColor(patternImage: UIImage.asset(.headerBackgroundImage)!)

    }
}
