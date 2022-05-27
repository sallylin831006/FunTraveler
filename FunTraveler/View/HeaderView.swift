//
//  HeaderView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundConfiguration = nil
        let margins = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
        
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHeaderView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHeaderView()
    }

    private func setupHeaderView() {

    }

}
