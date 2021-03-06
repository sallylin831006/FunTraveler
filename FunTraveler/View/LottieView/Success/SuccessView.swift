//
//  SuccessView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/24.
//

import UIKit
import Lottie

class SuccessView: UIView {
    
    private let successView = AnimationView()
    
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
        successView.stickView(successView, self)
    }
    
    private func lottieSetting() {
        successView.animation = Animation.named(LottieConstants.success)
        successView.contentMode = .scaleAspectFit
        successView.animationSpeed = 3
        successView.loopMode = .playOnce

        successView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.playOnce,
                           completion: { (finished) in
            if finished {
                self.successView.isHidden = true
                self.successView.removeFromSuperview()
            }
        })
        
    }
}
