//
//  RatingView.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/15.
//

import UIKit
import Lottie

class RatingView: UIView {
    
    private let ratingContentView = AnimationView()
//    private let ratingContentView = UIView()

    private let happyView = AnimationView()
    private let cryView = AnimationView()

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
        self.backgroundColor = .red.withAlphaComponent(0.4)
        setupAnimationView()
        
//        let tap = UITapGestureRecognizer(target: ratingContentView, action: #selector(UIView.endEditing))
//        tap.cancelsTouchesInView = false
//        ratingContentView.addGestureRecognizer(tap)
//        lottieSetting()
    }
    let iconWidth: CGFloat = 50
    private func setupAnimationView() {
       
        
//        ratingContentView.stickView(ratingContentView, self)
        addSubview(ratingContentView)
        ratingContentView.backgroundColor = .themePink
        ratingContentView.translatesAutoresizingMaskIntoConstraints = false
        ratingContentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        ratingContentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        ratingContentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        ratingContentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        animationSetting(ratingContentView, Animation.named(LottieConstants.success)!)

        
        ratingContentView.addSubview(happyView)
        happyView.translatesAutoresizingMaskIntoConstraints = false
        happyView.centerXAnchor.constraint(equalTo: centerXAnchor,constant: 100).isActive = true
        happyView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        happyView.widthAnchor.constraint(equalToConstant: iconWidth).isActive = true
        happyView.heightAnchor.constraint(equalToConstant: iconWidth).isActive = true
        animationSetting(happyView, Animation.named(LottieConstants.loading)!)
        
        ratingContentView.addSubview(cryView)
        cryView.translatesAutoresizingMaskIntoConstraints = false
        cryView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -100).isActive = true
        cryView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cryView.widthAnchor.constraint(equalToConstant: iconWidth).isActive = true
        cryView.heightAnchor.constraint(equalToConstant: iconWidth).isActive = true
        animationSetting(cryView, Animation.named(LottieConstants.success)!)
    }
    
    private func animationSetting(_ animationView: AnimationView,_ animation:  Animation) {
        animationView.isHidden = false
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        animationView.loopMode = .playOnce

        animationView.play(fromProgress: 0,
                           toProgress: 5,
                       loopMode: LottieLoopMode.playOnce,
                           completion: { (finished) in
            if finished {
                animationView.isHidden = true
                animationView.removeFromSuperview()
                self.removeFromSuperview()
            }
        })
        
    }
    
//    private func lottieSetting() {
//        ratingContentView.animation = Animation.named(LottieConstants.success)
//        ratingContentView.contentMode = .scaleAspectFit
//        ratingContentView.animationSpeed = 10
//        ratingContentView.loopMode = .playOnce
//
//        ratingContentView.play(fromProgress: 0,
//                           toProgress: 10,
//                       loopMode: LottieLoopMode.playOnce,
//                           completion: { (finished) in
//            if finished {
//                self.ratingContentView.isHidden = true
//                self.ratingContentView.removeFromSuperview()
//            }
//        })
//
//    }
}

