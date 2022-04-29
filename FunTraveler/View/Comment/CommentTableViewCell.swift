//
//  CommentTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/26.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var userNameButton: UIButton!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = 45/2
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .themeApricot
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func layoutCell(data: Comment) {
        userNameButton.setTitle(data.user.name, for: .normal)
        commentLabel.text = data.content
        
        if data.user.imageUrl == "" {
            userImageView.backgroundColor = .systemGray
        } else {
            userImageView.loadImage(data.user.imageUrl)
        }
        
    }
    
}
