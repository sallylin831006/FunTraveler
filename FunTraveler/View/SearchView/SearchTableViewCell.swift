//
//  SearchTableViewCell.swift
//  GoogleMapAPI
//
//  Created by 林翊婷 on 2022/4/9.
//

import UIKit

protocol SearchTableViewCellDelegate: AnyObject {
    func addNewSchedule(_ sender: UIButton)
}

class SearchTableViewCell: UITableViewCell {
    
    weak var delegate: SearchTableViewCellDelegate?
    
    var searchData = [Results]()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var actionBtn: UIButton!
    
    var searchDataClosure: (() -> Void)?
    
    func layoutCell(data: Results, index: Int) {
        
        nameLabel?.text = data.name
        ratingLabel?.text = "★★★★☆\(data.rating ?? 0.0)"
        addressLabel?.text = data.vicinity
        actionBtn.addTarget(self, action: #selector(tapActionButton(_:)), for: .touchUpInside)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .themeApricot
        
    }
    
    @objc func tapActionButton(_ sender: UIButton) {
        delegate?.addNewSchedule(sender)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        actionBtn.layer.cornerRadius = CornerRadius.buttonCorner
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        searchDataClosure?()
    }
    
}
