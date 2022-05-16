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
        let okAction = UIAlertAction(title: "確定發布", style: .default) { [unowned controller] _ in
            let locationText = controller.textFields?[0].text ?? ""
            self.saveVideoToPhotos(locationText: locationText)
           print(locationText)
        }
        
        
        let cancelAction = UIAlertAction(title: "放棄", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        controller.addAction(cancelAction)
        controller.addAction(okAction)
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
                    tabBarController.selectedIndex = 3
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
