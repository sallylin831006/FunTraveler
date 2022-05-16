//
//  VideoViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/11.
//

import UIKit

class VideoViewController: UIViewController {
    
    var refreshControl: UIRefreshControl!
    
    private var videoDataSource: [Video] = []
    private var indexOfSection: Int = 0

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    // MARK: - icon Animation
    private var iconFrame: CGFloat = 0
    let bgImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        return imageView
    }()
    
    let iconsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white

        let iconHeight: CGFloat = 38
        let padding: CGFloat = 6
        
        let images = [#imageLiteral(resourceName: "blue_like"), #imageLiteral(resourceName: "red_heart"), #imageLiteral(resourceName: "surprised"), #imageLiteral(resourceName: "cry_laugh"), #imageLiteral(resourceName: "cry"), #imageLiteral(resourceName: "angry")]
        
        let arrangedSubviews = images.map({ (image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2

            imageView.isUserInteractionEnabled = true
            return imageView

        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)
        
        let numIcons = CGFloat(arrangedSubviews.count)
        let width =  numIcons * iconHeight + (numIcons + 1) * padding
        
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        containerView.layer.cornerRadius = containerView.frame.height / 2
        
        // shadow
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        stackView.frame = containerView.frame
        
        return containerView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isPagingEnabled = true

        tableView.rowHeight = UITableView.automaticDimension
        let shotTableViewCellIdentifier = "ShotTableViewCell"
        let loadingCellTableViewCellCellIdentifier = "LoadingCellTableViewCell"
        tableView.registerCellWithNib(identifier: String(describing: shotTableViewCellIdentifier.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: loadingCellTableViewCellCellIdentifier.self), bundle: nil)
        tableView.registerHeaderWithNib(identifier: String(describing: VideoHeaderView.self), bundle: nil)

        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
 
        view.addSubview(bgImageView)
        bgImageView.frame = view.frame
              
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopVideo()
    }
    
    func stopVideo() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView, appEnteredFromBackground: true, isVideoStop: true)
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startPlayeVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            startPlayeVideos()
        }
    }
    
    func startPlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView, appEnteredFromBackground: true)
        stopVideo()
    }
}


extension VideoViewController: ShotTableViewCellDelegate {

    func detectDoubleClick(_ index: Int, gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {
            
            switch iconFrame {
            case 6.0:
                onShowIcon(UIImage(named: "blue_like")!)
                postLikeVideo(type: 1, index: index)
            case 50.0:
                postLikeVideo(type: 2, index: index)
                onShowIcon(UIImage(named: "red_heart")!)
            case 94.0:
                postLikeVideo(type: 3, index: index)
                onShowIcon(UIImage(named: "surprised")!)
            case 138.0:
                postLikeVideo(type: 4, index: index)
                onShowIcon(UIImage(named: "cry_laugh")!)
            case 182.0:
                postLikeVideo(type: 5, index: index)
                onShowIcon(UIImage(named: "cry")!)
            case 226.0:
                postLikeVideo(type: 6, index: index)
                onShowIcon(UIImage(named: "angry")!)
            default:
                onShowIcon(UIImage(named: "blue_like")!)
            }
        
            
            // clean up the animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: 50)
                self.iconsContainerView.alpha = 0
                
            }, completion: { (_) in
                self.iconsContainerView.removeFromSuperview()
            })
            
            
        } else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    
    fileprivate func handleGestureChanged(gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: self.iconsContainerView)
//        print(pressedLocation)

        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconsContainerView.frame.height / 2)
        
        let hitTestView = iconsContainerView.hitTest(fixedYLocation, with: nil)
        
        if hitTestView is UIImageView {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
                guard let hitTestView = hitTestView else { return }
                self.iconFrame = hitTestView.frame.minX
                
            })
        }
    }
    
    private func onShowIcon(_ image: UIImage) {
        let iconView = UIImageView()
        iconView.image = image
        let iconWidth: CGFloat = 100
        iconView.frame = CGRect(x: UIScreen.width/2 - iconWidth/2, y: UIScreen.height/2 - iconWidth/2, width: iconWidth, height: iconWidth)
        self.view.addSubview(iconView)
        iconView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 3.0,
          options: .allowUserInteraction,
          animations: { [weak self] in
            iconView.transform = .identity
          },
          completion: {_ in
            iconView.isHidden = true  }
        )
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        view.addSubview(iconsContainerView)
        
        let pressedLocation = gesture.location(in: self.view)
        
        // transformation of the red box
        let centeredX = (view.frame.width - iconsContainerView.frame.width) / 2
        
        iconsContainerView.alpha = 0
        self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.iconsContainerView.alpha = 1
            self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconsContainerView.frame.height)
        })
    }
    
    
}


extension VideoViewController: UITableViewDelegate, UITableViewDataSource  {
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: VideoHeaderView.identifier)
                as? VideoHeaderView else { return nil }
        headerView.layoutHeaderView(data: videoDataSource, section: section)
        headerView.delegate = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        videoDataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.safeAreaLayoutGuide.layoutFrame.height - 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ShotTableViewCell", for: indexPath)
                as? ShotTableViewCell else { return UITableViewCell() }
        self.indexOfSection = indexPath.section
        cell.layoutCell(data: videoDataSource[indexPath.section], index: indexPath.section)
        
        cell.configureCell(videoUrl: videoDataSource[indexPath.section].url)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }

}

extension VideoViewController {
    // MARK: - GET Videos
    private func fetchData() {
        ProgressHUD.show()
        let videoProvider = VideoProvider()
        videoProvider.fetchVideo(completion: { [weak self] result in
            ProgressHUD.dismiss()
            switch result {

            case .success(let videoData):
                DispatchQueue.main.async {
                    self?.tableView.delegate = self
                }
                self?.videoDataSource = videoData
                self?.tableView.reloadData()
                self?.startPlayeVideos()
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("[CameraVC] GET video失敗！")
            }
        })
    }

    // MARK: - POST TO INVITE
    private func postToInvite(section: Int) {
        let friendsProvider = FriendsProvider()
//        guard let userId = KeyChainManager.shared.userId else { return }
//        guard let userIdNumber = Int(userId) else { return }

        let userId =  videoDataSource[section].user.id
        friendsProvider.postToInvite(userId: userId, completion: { result in

            switch result {

            case .success(let postResponse):
                print("postResponse", postResponse)

            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("[VedioVC] POST TO INVITE失敗！")
            }
        })
    }

    // MARK: - POST To Block User
    private func postToBlockUser(index: Int) {
        let userProvider = UserProvider()
        let userId = videoDataSource[index].user.id
        userProvider.blockUser(userId: userId, completion: { [weak self] result in

            switch result {

            case .success:
                ProgressHUD.showSuccess(text: "已封鎖")
                self?.fetchData()

            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
            }
        })
    }
    
    // MARK: - POST Like Video
    private func postLikeVideo(type: Int, index: Int) {
        let videoProvider = VideoProvider()
        let videoId = videoDataSource[index].id

        videoProvider.postLikeVideo(videoId: videoId, type: type, completion: { [weak self] result in

            switch result {

            case .success(let ratingResponse):
                DispatchQueue.main.async {
                    self?.videoDataSource[index].ratings.type = ratingResponse.type

                    let sectionIndex = IndexSet(integer: index)
                    self?.tableView.reloadSections(sectionIndex, with: .none)
                }
                
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
            }
        })
    }

}

extension VideoViewController: VideoWallHeaderViewDelegate {
    func tapToUserProfile(_ section: Int) {
        guard KeyChainManager.shared.token != nil else { return onShowLogin()  }
        guard let profileVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: StoryboardCategory.profile) as? ProfileViewController else { return }

        profileVC.userId = self.videoDataSource[section].user.id
        profileVC.delegate = self
        if String(self.videoDataSource[section].user.id) == KeyChainManager.shared.userId {
            profileVC.isMyProfile = true
        } else {
            profileVC.isMyProfile = false
        }
        self.present(profileVC, animated: true)
    }
    
    func tapToFollow(_ followButton: UIButton, _ section: Int) {
        guard KeyChainManager.shared.token != nil else { return onShowLogin() }
        postToInvite(section: section)
        followButton.setTitle("已送出邀請", for: .normal)
        followButton.backgroundColor = .themePink
        followButton.isUserInteractionEnabled = false
    }
    
    func blockUser(_ blockButton: UIButton, _ index: Int) {
        guard KeyChainManager.shared.token != nil else { return onShowLogin()  }
        guard let userId = KeyChainManager.shared.userId else { return }
        guard let userIdNumber = Int(userId) else { return }
        if userIdNumber == self.videoDataSource[index].user.id { return }
        
        let userName = videoDataSource[index].user.name
        let blockController = UIAlertController(
            title: "封鎖用戶或檢舉動態",
            message: "", preferredStyle: .alert)
        
        let blockAction = UIAlertAction(title: "封鎖此用戶", style: .destructive, handler: { (_) in
            self.postToBlockUser(index: index)
        })

        let reportAction = UIAlertAction(title: "檢舉此動態", style: .destructive, handler: { (_) in
            ProgressHUD.showSuccess(text: "收到您的檢舉，團隊將在24小時盡快內處理")
        })
        
        let blockAndReportAction = UIAlertAction(title: "封鎖並檢舉此動態", style: .destructive, handler: { (_) in
            ProgressHUD.showSuccess(text: "已封鎖該用戶，且團隊將在24小時盡快內處理您的檢舉")
            self.postToBlockUser(index: index)
            
        })

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        blockController.addAction(blockAction)
        blockController.addAction(reportAction)
        blockController.addAction(blockAndReportAction)
        blockController.addAction(cancelAction)
        present(blockController, animated: true, completion: nil)
    }
    
    private func onShowLogin() {
        guard let authVC = UIStoryboard.auth.instantiateViewController(
            withIdentifier: StoryboardCategory.authVC) as? AuthViewController else { return }
        let navAuthVC = UINavigationController(rootViewController: authVC)
        present(navAuthVC, animated: true, completion: nil)
    }
   
}


extension VideoViewController: ProfileViewControllerDelegate {
    func detectProfileDissmiss(_ viewController: UIViewController) {
        fetchData()
    }
    
}
