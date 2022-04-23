//
//  PlayerViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/23.
//

import AVKit
import Photos

class PlayerViewController: UIViewController {
    var videoURL: URL!
    
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    @IBOutlet weak var videoView: UIView!

    @IBAction func saveVideo(_ sender: Any) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
          switch status {
          case .authorized:
            self?.saveVideoToPhotos()
          default:
            print("Photos permissions not granted.")
            return
          }
        }
      }
    
    private func saveVideoToPhotos() {
        PHPhotoLibrary.shared().performChanges({

            PHAssetChangeRequest.creationRequestForAssetFromVideo(
                atFileURL: self.videoURL)}) { [weak self] (isSaved, error) in
            if isSaved {
                print("Video saved.")
            } else {
                print("Cannot save video.")
                print(error ?? "unknown error")
            }
            DispatchQueue.main.async {
                self?.dismiss(animated: true, completion: nil)
                self?.presentingViewController?.navigationController?.popViewController(animated: true)

//                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupVideoView()
//        setupVideoButton()

        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        player.play()
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: nil) { [weak self] _ in self?.restart() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    private func restart() {
        player.seek(to: .zero)
        player.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil)
    }
}

// extension PlayerViewController {
//
//    //    private weak var videoView: UIView!
//
//    //    @objc func saveVideoButtonTapped() {
//    //        PHPhotoLibrary.requestAuthorization { [weak self] status in
//    //            switch status {
//    //            case .authorized:
//    //                self?.saveVideoToPhotos()
//    //            default:
//    //                print("Photos permissions not granted.")
//    //                return
//    //            }
//    //        }
//    //    }
//
//    func setupVideoView() {
//        self.view.addSubview(videoView)
//        videoView.translatesAutoresizingMaskIntoConstraints = false
//        videoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
//        videoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
//        videoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//
//    }
//
//    func setupVideoButton() {
//        let videoButton = UIButton()
//        videoButton.backgroundColor = .red
//        self.view.addSubview(videoButton)
//        videoButton.addTarget(self, action: #selector(saveVideoButtonTapped), for: .touchUpInside)
//        videoButton.translatesAutoresizingMaskIntoConstraints = false
//        videoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        videoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
//        videoButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        videoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    }
//
//}
