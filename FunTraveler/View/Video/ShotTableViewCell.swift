//
//  ShotTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/11.
//

import UIKit
import AVFoundation

protocol ShotTableViewCellDelegate: AnyObject {
    func detectDoubleClick(_ index: Int, gesture: UILongPressGestureRecognizer)
}

class ShotTableViewCell: UITableViewCell, ASAutoPlayVideoLayerContainer {
    weak var delegate: ShotTableViewCellDelegate?
    
    let screenImageView =  UIImageView()
    
    private let locationLabel = UILabel()
    private let dateLabel = UILabel()
    private var index: Int = 0
    private var iconViewArray: [UIImage] = []
    
    private func switchIcon(_ type: Int) -> UIImage {
        switch type {
            
        case 1:
            return UIImage(named: "blue_like")!
        case 2:
            return UIImage(named: "red_heart")!
        case 3:
            return UIImage(named: "surprised")!
        case 4:
            return UIImage(named: "cry_laugh")!
        case 5:
            return  UIImage(named: "cry")!
        case 6:
            return  UIImage(named: "angry")!
        default:
            return UIImage()
        }
        
    }
    
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    
    private var iconView = UIView()
    
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    private var iconViewImage: [UIImageView] = []
    
    func layoutCell(data: Video, index: Int) {
        self.index = index
        locationLabel.text = data.location
        dateLabel.text = data.createdTime
        
        iconViewArray = []
        for type in  data.ratings.type {
            let icon = switchIcon(type)
            iconViewArray.append(icon)
        }
        
        for image in iconViewImage {
            image.removeFromSuperview()
        }
        iconViewImage = [UIImageView]()
        
        iconView.removeFromSuperview()
        for (index, iconImage) in iconViewArray.enumerated() {
            let iconView = UIImageView()
            iconView.image = iconImage
            
            let width: CGFloat = 25
            let leading = UIScreen.width * 1/5 / 2 + 10
            iconView.frame = CGRect(x: leading + CGFloat(index)*(width + 1),
                                    y: UIScreen.width * 4/5 * 1.8, width: width, height: width)
            
            self.addSubview(iconView)
            iconViewImage.append(iconView)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .themeApricot
        
        setupImageView()
        setupDateLabel()
        setupLocationLabel()
        
        screenImageView.layer.cornerRadius = 5
        screenImageView.image = UIImage.asset(.videoPlaceHolder)
        screenImageView.clipsToBounds = true
        screenImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        screenImageView.layer.borderWidth = 3
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        screenImageView.layer.addSublayer(videoLayer)
        selectionStyle = .none
        
        setupLongPressGesture()
        
    }
    
    fileprivate func setupLongPressGesture() {
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        delegate?.detectDoubleClick(index, gesture: gesture)
    }
    
    func configureCell(videoUrl: String?) {
        self.videoURL = videoUrl
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoLayer.borderWidth = 3
        videoLayer.borderColor = UIColor.white.cgColor
        videoLayer.frame = screenImageView.bounds
    }
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(
            screenImageView.frame, from: screenImageView)
        guard let videoFrame = videoFrameInParentSuperView,
              let superViewFrame = superview?.frame else {
                  return 0
              }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
    
    func setupImageView() {
        self.addSubview(screenImageView)
        let width = UIScreen.width * 4/5
        let height = width * 1.8
        screenImageView.centerViewWithSize(screenImageView, self, width: width, height: height)
    }
    
    func setupDateLabel() {
        self.addSubview(dateLabel)
        dateLabel.textAlignment = .right
        dateLabel.font = UIFont(name: UIFont.AppleColorEmoji.colorEmoji.rawValue, size: 10)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.rightAnchor.constraint(equalTo: screenImageView.rightAnchor, constant: -20).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        dateLabel.bottomAnchor.constraint(equalTo: screenImageView.bottomAnchor, constant: 0).isActive = true
    }
    
    func setupLocationLabel() {
        self.addSubview(locationLabel)
        locationLabel.textAlignment = .right
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.rightAnchor.constraint(equalTo: screenImageView.rightAnchor, constant: -20).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        locationLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 0).isActive = true
    }
    
    func setupIconArray() {
        
        for (index, iconImage) in iconViewArray.enumerated() {
            
            let iconView = UIImageView()
            iconView.image = iconImage
            
            let width: CGFloat = 25
            let leading = UIScreen.width * 1/5 / 2 + 10
            iconView.frame = CGRect(x: leading + CGFloat(index)*(width + 1),
                                    y: UIScreen.width * 4/5 * 1.8, width: width, height: width)
            
            iconView.removeFromSuperview()
            self.addSubview(iconView)
        }
    }
    
}
