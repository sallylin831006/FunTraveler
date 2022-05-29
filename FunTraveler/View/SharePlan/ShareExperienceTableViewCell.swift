//
//  ShareExperienceTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/16.
//

import UIKit

protocol ShareExperienceTableViewCellDelegate: AnyObject {
    func detectTextViewChange(_ textView: UITextView, _ index: Int)
    
    func detectUploadImage(_ tripImage: UIImageView, _ imageRecognizer: UITapGestureRecognizer, _ index: Int)
}

class ShareExperienceTableViewCell: UITableViewCell {
    
    weak var delegate: ShareExperienceTableViewCellDelegate?
    
    @IBOutlet weak var orderLbael: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var tripTimeLabel: UILabel!
    
    @IBOutlet weak var tripImage: UIImageView!
    
    @IBOutlet weak var storiesTextView: UITextView!
    
    private var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .themeApricot
        self.selectionStyle = .none
        storiesTextView.delegate = self
        tripImage.contentMode = .scaleAspectFill
        tripImage.clipsToBounds = true
    }
    
    func layoutCell(data: Schedule, index: Int) {
        self.index = index
        orderLbael.text = String(index+1)
        nameLabel.text = data.name
        addressLabel.text = data.address
        tripTimeLabel.text = "停留時間：\(data.duration)小時"
        
        if data.description.isEmpty {
            storiesTextView.text = ""
        } else {
            storiesTextView.text = data.description
        }
        
        if data.images.isEmpty {
            tripImage.image = nil
        } else {
            tripImage.loadImage(data.images.first, placeHolder: UIImage.asset(.imagePlaceholder))
        }
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        tripImage.addGestureRecognizer(imageTapGesture)
        tripImage.isUserInteractionEnabled = true
        
    }
    
    @objc func profileTapped(sender: UITapGestureRecognizer) {
        delegate?.detectUploadImage(tripImage, sender, index)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        tripImage.layer.borderColor = UIColor.white.cgColor
        tripImage.layer.borderWidth = 2
        tripImage.layer.cornerRadius = 10.0
        tripImage.layer.masksToBounds = true
    }
    
}

extension ShareExperienceTableViewCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.detectTextViewChange(textView, index)
    }
}
