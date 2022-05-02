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
    
    @IBOutlet weak var ownerImageView: UIImageView!
    
    
    @IBOutlet weak var departmentPickerView: TimePickerView!
    
    @IBOutlet weak var selectionView: SegmentControlView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var inviteButton: UIButton!
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

     
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ownerImageView.layer.cornerRadius = ownerImageView.frame.width/2
        ownerImageView.contentMode = .scaleAspectFill
        ownerImageView.layer.borderWidth = 4
        ownerImageView.layer.borderColor = UIColor.themeApricot?.cgColor
        contentView.backgroundColor = UIColor.themeLightBlue
        contentView.layer.cornerRadius = 12
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func layoutHeaderView(data: Trip) {
        ownerImageView.loadImage(data.user.imageUrl)
    }

}

extension PlanCardHeaderView: PlanPickerViewControllerDelegate {
    func reloadCollectionView(_ collectionView: UICollectionView) {
        collectionView.reloadData()
    }
    
    
}
