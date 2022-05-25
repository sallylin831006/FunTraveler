//
//  SharePlanTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/15.
//

import UIKit

class SharePlanTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderLbael: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var tripTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .themeApricot
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func layoutCell(data: Schedule, index: Int) {
        orderLbael.text = String(index+1)
        nameLabel.text = data.name
        addressLabel.text = data.address
        tripTimeLabel.text = "停留時間：\(data.duration)小時"
    }
    
}
