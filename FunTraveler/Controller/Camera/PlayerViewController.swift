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
              DispatchQueue.main.async {
                  self?.showInputTextfield()
              }

          default:
            print("Photos permissions not granted.")
            return
          }
        }
      }
    
    private func showInputTextfield() {
        let controller = UIAlertController(title: "旅遊動態", message: "輸入地點發布你的旅遊回憶", preferredStyle: .alert)
        controller.addTextField { textField in
           textField.placeholder = "輸入地點"
            textField.keyboardType = UIKeyboardType.default
        }
        let okAction = UIAlertAction(title: "確定", style: .default) { [unowned controller] _ in
            let locationText = controller.textFields?[0].text ?? ""
            self.saveVideoToPhotos(locationText: locationText)
           print(locationText)
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    private func saveVideoToPhotos(locationText: String) {
        PHPhotoLibrary.shared().performChanges({

            PHAssetChangeRequest.creationRequestForAssetFromVideo(
                atFileURL: self.videoURL)}) { [weak self] (isSaved, error) in
            if isSaved {
                self?.postVideoData(locationText: locationText, url: (self?.videoURL)!)
                print("Video saved.")
            } else {
                ProgressHUD.showFailure()
                print("Cannot save video.")
                print(error ?? "unknown error")
            }
        }
    }
    func postVideoData(locationText: String, url: URL) {
        ProgressHUD.show()
        let video = try? Data(contentsOf: url, options: .mappedIfSafe)
        let dataPath = ["file": video!]
        let parameters = [
            "location": locationText
        ]
        VideoManager().requestWithFormData(urlString: "https://travel.newideas.com.tw/api/v1/videos",
                                           parameters: parameters, dataPath: dataPath, completion: { (_) in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
                self.presentingViewController?.navigationController?.popViewController(animated: true)
                if let tabBarController = self.presentingViewController as? UITabBarController {
                    tabBarController.selectedIndex = 1
                }
            }
            
            
        })
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
