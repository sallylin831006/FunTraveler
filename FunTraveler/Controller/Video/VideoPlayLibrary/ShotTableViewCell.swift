//
//  ShotTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/11.
//

import UIKit
import AVFoundation
class ShotTableViewCell: UITableViewCell, ASAutoPlayVideoLayerContainer {
    
    let screenImageView =  UIImageView()
    
    private let locationLabel = UILabel()
    private let dateLabel = UILabel()
  
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    func layoutCell(data: Video, index: Int) {
        locationLabel.text = data.location
        dateLabel.text = data.createdTime
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .themeApricot
//        self.layer.borderColor = UIColor.themeApricot?.cgColor
//        self.layer.borderWidth = 20
        setupImageView()
//        setupVedioHeaderView()
        setupDateLabel()
        setupLocationLabel()
        
        screenImageView.layer.cornerRadius = 5
//        screenImageView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        screenImageView.image = UIImage.asset(.videoPlaceHolder)
        screenImageView.clipsToBounds = true
        screenImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        screenImageView.layer.borderWidth = 3
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        screenImageView.layer.addSublayer(videoLayer)
        selectionStyle = .none
    }
    
    func configureCell(videoUrl: String?) {
        self.videoURL = videoUrl
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        videoLayer.borderWidth = 3
        videoLayer.borderColor = UIColor.white.cgColor
        videoLayer.frame = screenImageView.bounds
        let margins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(screenImageView.frame, from: screenImageView)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
    
    
    
    func setupImageView() {
        self.addSubview(screenImageView)
        screenImageView.translatesAutoresizingMaskIntoConstraints = false
        screenImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true

        screenImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        screenImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        screenImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
 
    
    
    func setupDateLabel() {
        self.addSubview(dateLabel)
        dateLabel.textAlignment = .right
        dateLabel.font = UIFont(name: UIFont.AppleColorEmoji.colorEmoji.rawValue, size: 10)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.rightAnchor.constraint(equalTo: screenImageView.rightAnchor, constant: -15).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        dateLabel.bottomAnchor.constraint(equalTo: screenImageView.bottomAnchor, constant: -15).isActive = true
    }
    
    func setupLocationLabel() {
        self.addSubview(locationLabel)
        locationLabel.textAlignment = .right
        locationLabel.font = UIFont(name: UIFont.AppleColorEmoji.colorEmoji.rawValue, size: 16)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.rightAnchor.constraint(equalTo: screenImageView.rightAnchor, constant: -15).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        locationLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 0).isActive = true
    }
    
}
