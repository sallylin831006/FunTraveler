//
//  ShareHeaderView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/19.
//

import UIKit

protocol ShareHeaderViewDelegate: AnyObject {
    func configureNumberOfButton() -> Int
    
    func didSelectedButton(index: Int)
}

class ShareHeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: ShareHeaderViewDelegate?
    
    var collectClosure: ((_ isCollected: Bool) -> Void)?
    private var isCollected: Bool = false
    
    var collectButton = UIButton()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var selectionView: SegmentControlView!
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundConfiguration = nil
        titleLabel.text = "行程分享"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func layoutHeaderView(data: Trip) {
        collectButton.setImage(UIImage.asset(.collectedIconSelected), for: .selected)
        collectButton.setImage(UIImage.asset(.collectedIconNormal), for: .normal)
        self.isCollected = data.isCollected
        collectButton.isSelected = data.isCollected
        addCollectButton(data: data)
        guard let startDate = data.startDate,
              let endDate = data.endDate else { return }
        dateLabel.text = "\(startDate) - \(endDate)"
        titleLabel.text = data.title
        
    }
    
    func layoutSharePlanHeaderView(data: Trip) {
        titleLabel.text = data.title
        dateLabel.text = "\(data.startDate!) - \(data.endDate!)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectButton.addTarget(self, action: #selector(tapCollectButton), for: .touchUpInside)
        selectionView.delegate = self
        selectionView.dataSource = self
    }
    
    @objc func tapCollectButton(_ sender: UIButton) {
        sender.isSelected = !isCollected
        collectClosure?(!isCollected)
    }
    
    func addCollectButton(data: Trip) {
        collectButton.frame = CGRect(x: UIScreen.width - 50, y: 0, width: 30, height: 50)
        collectButton.setImage(UIImage.asset(.collectedIconSelected), for: .selected)
        collectButton.setImage(UIImage.asset(.collectedIconNormal), for: .normal)
        self.addSubview(collectButton)
        
        isCollected = data.isCollected
        collectButton.isSelected = data.isCollected
    }
}

extension ShareHeaderView: SegmentControlViewDataSource {
    
    func configureNumberOfButton(_ selectionView: SegmentControlView) -> Int {
        delegate?.configureNumberOfButton() ?? 1
    }
    
}

@objc extension ShareHeaderView: SegmentControlViewDelegate {
    func didSelectedButton(_ selectionView: SegmentControlView, at index: Int) {
        delegate?.didSelectedButton(index: index)
    }
    
}
