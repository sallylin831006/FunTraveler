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
    private var index: Int = 0
    private let ratingView = RatingView()
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
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

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(closeView), name: NSNotification.Name("CloseView"), object: nil)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeView(_:)))
        self.view.addGestureRecognizer(gesture)
        ratingView.addGestureRecognizer(gesture)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

       
                
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        print("上滑動")
        ratingView.removeFromSuperview()
    }
    
    @objc private func closeView(_ tapGestureRecognizer: UITapGestureRecognizer) {
        ratingView.removeFromSuperview()
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
        self.index = indexPath.row
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

extension VideoViewController: ShotTableViewCellDelegate {

    func detectDoubleClick(_ index: Int) {
        print("detectDoubleClick")
//        guard let ratingVC = storyboard?.instantiateViewController(
//            withIdentifier: StoryboardCategory.ratingVC) as? RatingViewController else { return }
//        ratingVC.delegate = self
//        addChild(ratingVC)
//        view.addSubview(ratingVC.view)
        
//        ratingView.stickView(ratingView, self.view)
        
        self.view.addSubview(ratingView)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ratingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        ratingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        ratingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 180).isActive = true

    }
    
    
}

extension VideoViewController: RatingViewControllerDelegate {
    func passingIncon(_ icon: UIImageView) {
        let iconView = UIImageView()
        iconView.image = UIImage.asset(.collectSelected)
        iconView.centerView(iconView, self.view, width: 100, height: 100)
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
