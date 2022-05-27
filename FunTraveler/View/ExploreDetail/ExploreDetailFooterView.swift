//
//  ExploreDetailFooterView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/19.
//

import UIKit

class ExploreDetailFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var copyButton: UIButton!
    
    @IBOutlet weak var moveToCommentButton: UIButton!
        
    @IBOutlet weak private var heartButton: UIButton!
    
    @IBOutlet weak private var numberOfLikeLabel: UILabel!
    
    var copyClosure: (() -> Void)?
    var collectClosure: ((_ isCollected: Bool) -> Void)?
    var heartClosure: ((_ isLiked: Bool) -> Void)?
    private var isCollected: Bool = false
    private var isLiked: Bool = false

    func layoutFooterView(data: Trip) {
        self.backgroundConfiguration = nil
        heartButton.touchEdgeInsets = UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
        heartButton.setImage(UIImage.asset(.heartSelected), for: .selected)
        heartButton.setImage(UIImage.asset(.heartNormalBlue), for: .normal)
        self.isLiked = data.isLiked
        heartButton.isSelected = data.isLiked
        numberOfLikeLabel.text = "\(data.likeCount)個讚"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .themeApricot
        copyButton.addTarget(self, action: #selector(tapCopyButton), for: .touchUpInside)
        heartButton.addTarget(self, action: #selector(tapHeartButton), for: .touchUpInside)
    }
    
    @objc func tapCollectButton(_ sender: UIButton) {
        sender.isSelected = !isCollected
        collectClosure?(!isCollected)
    }
    
    @objc func tapHeartButton(_ sender: UIButton) {
        sender.isSelected = !isLiked
        heartClosure?(!isLiked)
    }
    
    
    @objc func tapCopyButton(_ sender: UIButton) {
        copyClosure?()
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
        contentView.backgroundColor = UIColor.themeApricotDeep
    }

}
