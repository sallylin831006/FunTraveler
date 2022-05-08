//
//  ShareHeaderView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/19.
//

import UIKit

class ShareHeaderView: UITableViewHeaderFooterView {
    
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
    
    func layoutHeaderView(data: Trip) {
        collectButton.setImage(UIImage.asset(.collectedIconSelected), for: .selected)
        collectButton.setImage(UIImage.asset(.collectedIconNormal), for: .normal)
        self.isCollected = data.isCollected
        collectButton.isSelected = data.isCollected
        addCollectButton(data: data)
        dateLabel.text = "\(String(describing: data.startDate)) - \(String(describing: data.endDate))"
        
        titleLabel.text = data.title
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectButton.addTarget(self, action: #selector(tapCollectButton), for: .touchUpInside)
        
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
