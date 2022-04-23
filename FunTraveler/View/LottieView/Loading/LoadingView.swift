//
//  LoadingView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/24.
//

import UIKit
import Lottie

class LoadingView: UIView {
    
    private let loadingView = AnimationView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupAnimationView()
        lottieSetting()
    }
    
    private func setupAnimationView() {
        
        addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        loadingView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    private func lottieSetting() {
        loadingView.animation = Animation.named("LoadingDot")
        loadingView.contentMode = .scaleAspectFit
        loadingView.animationSpeed = 1.5
        loadingView.loopMode = .repeat(1)
        
        loadingView.play(completion: { [weak self] _ in
            guard let self = self else { return }
            self.loadingView.removeFromSuperview()
            
        })
    }
    
}
