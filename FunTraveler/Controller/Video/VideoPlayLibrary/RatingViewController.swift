//
//  RatingViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/14.
//

import UIKit

protocol RatingViewControllerDelegate : AnyObject {
    func passingIncon(_ icon: UIImageView)
    }


class RatingViewController: UIViewController {
    weak var delegate: RatingViewControllerDelegate?
    
    let loveIcon = UIButton()
    let angeryIcon = UIButton()
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var thumbsUpIcon: UIButton!
    
    @IBOutlet weak var angeryButton: UIButton!
    
    @IBOutlet weak var cryButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonAnimation()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    @IBAction func tabOnLikeButton(_ sender: Any) {
        
        let iconView = UIImageView()
        iconView.image = UIImage.asset(.collectSelected)
        delegate?.passingIncon(iconView)
        
        self.view.removeFromSuperview()
    }
    
    
    @IBAction func tapOnThumbsUpIcon(_ sender: Any) {
        self.view.removeFromSuperview()
    }

    
    private func buttonAnimation() {
        let usingSpringWithDamping = 0.3
        likeButton.transform = CGAffineTransform(scaleX: 0.5, y: 0)
        UIView.animate(withDuration: 3,
          delay: 0,
          usingSpringWithDamping: usingSpringWithDamping,
          initialSpringVelocity: 3.0,
          options: .allowUserInteraction,
          animations: { [weak self] in
            self?.likeButton.transform = .identity
          },
          completion: nil)
        
        thumbsUpIcon.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 3,
                       delay: 0.5,
                       usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: 3.0,
          options: .allowUserInteraction,
          animations: { [weak self] in
            self?.thumbsUpIcon.transform = .identity
          },
          completion: nil)
        
        
        angeryButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 3,
                       delay: 1,
                       usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: 3.0,
          options: .allowUserInteraction,
          animations: { [weak self] in
            self?.angeryButton.transform = .identity
          },
          completion: nil)
        
        cryButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 3,
                       delay: 1.5,
                       usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: 3.0,
          options: .allowUserInteraction,
          animations: { [weak self] in
            self?.cryButton.transform = .identity
          },
          completion: nil)
    }
    
}



extension RatingViewController {
    func setupLoveView() {
        
        loveIcon.backgroundColor = .red
        loveIcon.setBackgroundImage(UIImage.asset(.cameraNormal), for: .normal)
        
        self.view.addSubview(loveIcon)
//        loveIcon.addTarget(self, action: #selector(tapLoveIcon), for: .touchUpInside)
        loveIcon.translatesAutoresizingMaskIntoConstraints = false
        loveIcon.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        
        loveIcon.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
//        loveIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        loveIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        loveIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        loveIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupAngeryView() {
        angeryIcon.setBackgroundImage(UIImage.asset(.collectNormal), for: .normal)
        self.view.addSubview(angeryIcon)
        angeryIcon.translatesAutoresizingMaskIntoConstraints = false
        angeryIcon.leadingAnchor.constraint(equalTo: loveIcon.leadingAnchor, constant: 0).isActive = true
        
        angeryIcon.trailingAnchor.constraint(equalTo: loveIcon.trailingAnchor, constant: 0).isActive = true
        angeryIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        angeryIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
