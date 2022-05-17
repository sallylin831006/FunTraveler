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
    
    private var data: Trip?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
//        selectionView.delegate = self
//        selectionView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundConfiguration = nil
        ownerImageView.layer.cornerRadius = ownerImageView.frame.width/2
        ownerImageView.contentMode = .scaleAspectFill
        ownerImageView.layer.borderWidth = 2
        ownerImageView.layer.borderColor = UIColor.themeApricot?.cgColor
        contentView.backgroundColor = UIColor.themeLightBlue
        contentView.layer.cornerRadius = 12
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        guard let data = data else { return }
//        selectionView.configureButton(dayNumber: data.days)
    }
    
    func layoutHeaderView(data: Trip) {data
        if data.user.imageUrl == "" {
            ownerImageView.image = UIImage.asset(.defaultUserImage)
        } else {
            ownerImageView.loadImage(data.user.imageUrl, placeHolder: UIImage.asset(.imagePlaceholder))
        }
       
        titleLabel.text = data.title
        
        guard let startDate = data.startDate,
              let endtDate = data.endDate
        else { return }
        dateLabel.text = "\(startDate) - \(endtDate)"

//        selectionView.configureButton(dayNumber: data.days)
        self.data = data
        
    }

}

//extension PlanCardHeaderView: SegmentControlViewDataSource {
//    
//    func configureNumberOfButton(_ selectionView: SegmentControlView) -> Int {
//        data?.days ?? 1
//    }
//    
//}

//@objc extension PlanCardHeaderView: SegmentControlViewDelegate {
//    func didSelectedButton(_ selectionView: SegmentControlView, at index: Int) {
//        postData(days: currentDay, isFinished: false)
//        currentDay = index
//        currentdayClosure?(index)
//        fetchData(days: index)
//    }
//    
//    func shouldSelectedButton(_ selectionView: SegmentControlView, at index: Int) -> Bool {
//        return true
//    }
//}



extension PlanCardHeaderView: PlanPickerViewControllerDelegate {
    func reloadCollectionView(_ collectionView: UICollectionView) {
        collectionView.reloadData()
    }
}
