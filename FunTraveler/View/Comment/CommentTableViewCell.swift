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
    
    @IBOutlet weak var durationLabel: UILabel!
    
    
    @IBOutlet weak var replyButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.width/2
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
        
        if data.duration < 60 {
            durationLabel.text = "\(data.duration)分鐘"
        } else {
            let hour = Int(data.duration/60)
            let minute = data.duration - hour * 60
            durationLabel.text = "\(hour)小時\(minute)分鐘"
        }
        
        if data.user.imageUrl == "" {
            userImageView.image = UIImage.asset(.defaultUserImage)
        } else {
            userImageView.loadImage(data.user.imageUrl, placeHolder: UIImage.asset(.imagePlaceholder))
        }
        
    }
    
}
