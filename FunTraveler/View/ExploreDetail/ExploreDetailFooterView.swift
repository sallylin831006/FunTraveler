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
    
    
    var copyClosure: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        copyButton.addTarget(self, action: #selector(tapCopyButton), for: .touchUpInside)
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
