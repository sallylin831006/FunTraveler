//
//  ExploreDetailFooterView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/19.
//

import UIKit

class ExploreDetailFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var copyButton: UIButton!
    
    @IBOutlet weak var moveToCommentButton: UIButton!
    
    @IBOutlet weak var collectButton: UIButton!
    
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var numberOfLikeLabel: UILabel!
    
    var copyClosure: (() -> Void)?
    var collectClosure: ((_ isCollected: Bool) -> Void)?
    var heartClosure: ((_ isLiked: Bool) -> Void)?
    private var isCollected: Bool = false
    
    func layoutFooterView(data: Trip) {
        collectButton.setImage(UIImage.asset(.collectedIconSelected), for: .selected)
        collectButton.setImage(UIImage.asset(.collectedIconNormal), for: .normal)
        self.isCollected = data.isCollected
        collectButton.isSelected = data.isCollected
        
        heartButton.setImage(UIImage.asset(.heartSelected), for: .selected)
        heartButton.setImage(UIImage.asset(.heartNormal), for: .normal)
//        self.isLiked = data.isLiked
//        heartButton.isSelected = data.isLiked
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .themeApricot
        copyButton.addTarget(self, action: #selector(tapCopyButton), for: .touchUpInside)
        collectButton.addTarget(self, action: #selector(tapCollectButton), for: .touchUpInside)
        heartButton.addTarget(self, action: #selector(tapHeartButton), for: .touchUpInside)
    }
    
    @objc func tapCollectButton(_ sender: UIButton) {
        sender.isSelected = !isCollected
        collectClosure?(!isCollected)
    }
    
    @objc func tapHeartButton(_ sender: UIButton) {
//        sender.isSelected = !isLiked
//        heartClosure?(!isLiked)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupFooterView()
        
    }
    
    @objc func tapCopyButton(_ sender: UIButton) {
        copyClosure?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupFooterView()
    }

    private func setupFooterView() {
        contentView.backgroundColor = UIColor.themeApricotDeep
    }

}
