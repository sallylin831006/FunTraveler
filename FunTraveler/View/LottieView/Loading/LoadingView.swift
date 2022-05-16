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
        loadingView.stickView(loadingView, self)
    }
    
    private func lottieSetting() {
        loadingView.animation = Animation.named(LottieConstants.loading)
        loadingView.contentMode = .scaleAspectFit
        loadingView.animationSpeed = 3
        loadingView.loopMode = .playOnce

        loadingView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.playOnce,
                           completion: { (finished) in
            if finished {
                self.loadingView.isHidden = true
                self.loadingView.removeFromSuperview()
            }
        })
        
    }
    
}
