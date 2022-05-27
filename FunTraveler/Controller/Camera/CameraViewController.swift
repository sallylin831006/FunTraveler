//
//  CameraViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/18.
//

import UIKit
import MobileCoreServices
import AVKit

class CameraViewController: UIViewController {
    private let editor = VideoEditor()
    
    let activityIndicator =  UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        activityIndicator.isHidden = true
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        buttonAnimation()
    }
 
    @IBOutlet weak var pickVideoButton: UIButton!
    
    @IBOutlet weak var recordVideoButton: UIButton!
    
    @IBAction func recordVideo(_ sender: Any) {
        let loadingView = LoadingView()
        self.view.layoutLoadingView(loadingView, self.view)
        guard KeyChainManager.shared.token != nil else { return self.onShowLogin()  }
        pickVideo(from: .camera)
    }
        
    @IBAction func pickVideo(_ sender: Any) {
        let loadingView = LoadingView()
        self.view.layoutLoadingView(loadingView, self.view)
        guard KeyChainManager.shared.token != nil else { return self.onShowLogin()  }
        pickVideo(from: .savedPhotosAlbum)
    }
    
    private func onShowLogin() {
        guard let authVC = UIStoryboard.auth.instantiateViewController(
            withIdentifier: StoryboardCategory.authVC) as? AuthViewController else { return }
        let navAuthVC = UINavigationController(rootViewController: authVC)
        present(navAuthVC, animated: true, completion: nil)
    }
   
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

//        navigationItem.title = "拍立得"
        buttonAnimation()
    }
    
    private func buttonAnimation() {
        pickVideoButton.adjustsImageWhenHighlighted = false
        recordVideoButton.adjustsImageWhenHighlighted = false

        pickVideoButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 3,
          delay: 0,
          usingSpringWithDamping: 0.1,
          initialSpringVelocity: 3.0,
          options: .allowUserInteraction,
          animations: { [weak self] in
            self?.pickVideoButton.transform = .identity
          },
          completion: nil)
        
        recordVideoButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 3,
                       delay: 0.05,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 3.0,
          options: .allowUserInteraction,
          animations: { [weak self] in
            self?.recordVideoButton.transform = .identity
          },
          completion: nil)
    }
    
    private func pickVideo(from sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.mediaTypes = [kUTTypeMovie as String]
        pickerController.videoQuality = .typeIFrame1280x720
        pickerController.allowsEditing = true

        pickerController.videoMaximumDuration = TimeInterval(10.0)
        if sourceType == .camera {
            pickerController.cameraDevice = .rear
        }
        pickerController.delegate = self

        present(pickerController, animated: true)
    }
    
    private func showVideo(at url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    private var pickedURL: URL?
    
    private func showInProgress() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func showCompleted() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let url = info[.mediaURL] as? URL  else {
            print("Cannot get video URL")
            return
        }
        
        showInProgress()
        dismiss(animated: true) {
            self.editor.makeCustomEffect(fromVideoAt: url) { exportedURL in
                self.showCompleted()
                guard let exportedURL = exportedURL else {
                    return
                }
                self.pickedURL = exportedURL
                
                guard let playerViewController = self.storyboard?.instantiateViewController(
                    withIdentifier: "PlayerViewController") as? PlayerViewController else { return }
                
                let navPlayerViewController = UINavigationController(rootViewController: playerViewController)
                guard let url = self.pickedURL else { return }
                playerViewController.videoURL = url
                navPlayerViewController.modalPresentationStyle = .fullScreen
                self.present(navPlayerViewController, animated: true)
                
            }
        }
    }
}

extension CameraViewController {
    func setupActivityIndicator() {
        activityIndicator.centerViewWithSize(
            activityIndicator, view, width: 50, height: 50, centerXconstant: 0, centerYconstant: -10)
    }
    
}
