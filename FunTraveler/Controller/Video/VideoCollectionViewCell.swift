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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let playerView: PlayerView = {
        let view = PlayerView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
}

extension VideoCollectionViewCell {
    func setupContainerView() {
        self.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        containerView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true

    }
    func setupPlayerView() {
        self.containerView.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        playerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}
