//
//  ShotTableViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/11.
//

import UIKit
import AVFoundation

protocol ShotTableViewCellDelegate: AnyObject {
    func detectDoubleClick(_ index: Int)
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
    
//    private var iconViewArray: [UIImage] = [UIImage(named: "blue_like")!,
//                                    UIImage(named: "red_heart")!,
//                                    UIImage(named: "surprised")!,
//                                    UIImage(named: "cry_laugh")!,
//                                    UIImage(named: "cry")!,
//                                    UIImage(named: "angry")!]
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
        self.index = index
        locationLabel.text = data.location
        dateLabel.text = data.createdTime
//        data.ratings.type
        
        for type in  data.ratings.type {
            var icon = switchIcon(type)
            iconViewArray.append(icon)
        }
        setupIconArray()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .themeApricot
//        self.layer.borderColor = UIColor.themeApricot?.cgColor
//        self.layer.borderWidth = 20
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
        
        let doubleTapped = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapped.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapped)
        
        let oneTapped = UITapGestureRecognizer(target: self, action: #selector(oneTapped))
        oneTapped.numberOfTapsRequired = 1
        addGestureRecognizer(oneTapped)
    }
    
    @objc func doubleTapped() {
        delegate?.detectDoubleClick(index)
    }
    
    @objc func oneTapped() {
//        print("點了一下")
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
        screenImageView.widthAnchor.constraint(equalToConstant: UIScreen.width * 4/5).isActive = true
        screenImageView.heightAnchor.constraint(equalToConstant: UIScreen.width * 4/5 * 1.8).isActive = true
        screenImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        screenImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        screenImageView.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
//
//        screenImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
//        screenImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
//        screenImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
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
//        locationLabel.font = UIFont(name: UIFont.AppleColorEmoji.colorEmoji.rawValue, size: 16)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.rightAnchor.constraint(equalTo: screenImageView.rightAnchor, constant: -20).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true

        locationLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 0).isActive = true
    }
    
    let indicatorView = UIView()
    
    
    func setupIconArray(iconImage: UIImage = UIImage.asset(.cameraNormal)!) {
        for (index, iconImage) in iconViewArray.enumerated() {
            let iconView = UIImageView()
//            iconView.backgroundColor = .orange
            iconView.image = iconImage

            let width: CGFloat = 25
            let leading = UIScreen.width * 1/5 / 2 + 10
            iconView.frame = CGRect(x: leading + CGFloat(index)*(width + 1), y:  UIScreen.width * 4/5 * 1.8, width: width, height: width)
            self.addSubview(iconView)

        }
    }
    
}
