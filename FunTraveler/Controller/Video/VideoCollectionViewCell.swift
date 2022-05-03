//
//  VideoCollectionViewCell.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/23.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

//    let containerView = UIView()
    
//    let playerView = PlayerView()

    let playerView: PlayerView = {
        let view = PlayerView()
        view.clipsToBounds = true
        return view
    }()
    
//    let locationLabel: UILabel = {
//        let locationLabel = UILabel()
//        locationLabel.backgroundColor = .red
//        return locationLabel
//    }()
    
    private let locationLabel = UILabel()
    private let dateLabel = UILabel()

    var url: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
        containerView.backgroundColor = .clear
        containerView.backgroundColor = .clear
        playerView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpUI()
    }
    
    func setUpUI() {
        setupContainerView()
        setupPlayerView()
        setupDateLabel()
        setupLocationLabel()
    }
    
    @objc func volumeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        playerView.isMuted = sender.isSelected
        PlayerView.videoIsMuted = sender.isSelected
    }
    
    func play() {
        if let url = url {
            playerView.prepareToPlay(withUrl: url, shouldPlayImmediately: true)
        }
    }
    
    func pause() {
        playerView.pause()
    }
    
    func configure(_ videoUrl: String) {
        guard let url = URL(string: videoUrl) else { return }
        self.url = url
        playerView.prepareToPlay(withUrl: url, shouldPlayImmediately: false)
    }
    
    func layoutCell(data: Video, index: Int) {
        locationLabel.text = data.location
        dateLabel.text = data.createdTime
    }

}

extension VideoCollectionViewCell {
    func setupContainerView() {
        self.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        containerView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true

    }
    func setupPlayerView() {
        self.containerView.addSubview(playerView)
        playerView.clipsToBounds = true
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        playerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        playerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func setupDateLabel() {
        self.containerView.addSubview(dateLabel)
        dateLabel.textAlignment = .right
        dateLabel.font = UIFont(name: UIFont.AppleColorEmoji.colorEmoji.rawValue, size: 10)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.rightAnchor.constraint(equalTo: playerView.rightAnchor, constant: -20).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: playerView.leftAnchor, constant: 60).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        dateLabel.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -10).isActive = true
    }
    
    func setupLocationLabel() {
        self.containerView.addSubview(locationLabel)
        locationLabel.textAlignment = .right
        locationLabel.font = UIFont(name: UIFont.AppleColorEmoji.colorEmoji.rawValue, size: 16)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.rightAnchor.constraint(equalTo: playerView.rightAnchor, constant: -20).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: playerView.leftAnchor, constant: 60).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        locationLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 0).isActive = true
    }
    
}
