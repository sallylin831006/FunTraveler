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
    let videoHeaderView =  UIView()

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageView()
//        setupVedioHeaderView()
        screenImageView.layer.cornerRadius = 5
        screenImageView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        screenImageView.clipsToBounds = true
        screenImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        screenImageView.layer.borderWidth = 0.5
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        screenImageView.layer.addSublayer(videoLayer)
        selectionStyle = .none
    }
    
    func configureCell(videoUrl: String?) {
        self.videoURL = videoUrl
    }
 

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoLayer.borderWidth = 3
        videoLayer.borderColor = UIColor.white.cgColor
        videoLayer.frame = screenImageView.bounds
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

        screenImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100).isActive = true
        screenImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        screenImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
    }

    
    func setupVedioHeaderView() {
        self.addSubview(videoHeaderView)
        videoHeaderView.translatesAutoresizingMaskIntoConstraints = false
        videoHeaderView.backgroundColor = .orange
        videoHeaderView.bottomAnchor.constraint(equalTo: screenImageView.topAnchor, constant: 10).isActive = true
        videoHeaderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        videoHeaderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        videoHeaderView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        videoHeaderView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
