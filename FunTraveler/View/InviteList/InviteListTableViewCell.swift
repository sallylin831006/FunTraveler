//
//  InviteListTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/29.
//

import UIKit

protocol InviteListTableViewCellDelegate: AnyObject {
    func confirmInvitation(index: Int, isAccept: Bool)
    func cancelInvitation(index: Int, isAccept: Bool)

}

class InviteListTableViewCell: UITableViewCell {
    
    weak var delegate: InviteListTableViewCellDelegate?
    
    private var index: Int = 0
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var confirmInviteButton: UIButton!
    
    @IBOutlet weak var cancelInviteButton: UIButton!
    
    @IBAction func tapConfirmButton(_ sender: Any) {

        delegate?.confirmInvitation(index: index, isAccept: true)
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        delegate?.cancelInvitation(index: index, isAccept: false)
    }
    
    func layoutCell(data: User, index: Int) {
        userImageView.loadImage(data.imageUrl)
        nameLabel.text = data.name
        self.index = index
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .themeApricot
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
