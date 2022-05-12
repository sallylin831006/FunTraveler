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

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.isPagingEnabled = true

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
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource  {
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: VideoHeaderView.identifier)
                as? VideoHeaderView else { return nil }
        headerView.layoutHeaderView(data: videoDataSource, section: section)
        headerView.delegate = self
        
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        videoDataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("UIScreen.main.bounds.height", UIScreen.main.bounds.height)
        print("view.safeAreaLayoutGuide.layoutFrame.height", view.safeAreaLayoutGuide.layoutFrame.height)
        let heightOfnavigationBar = navigationController?.navigationBar.frame.height ?? 44
        let heightOfTabBar = tabBarController?.tabBar.frame.height
        return view.safeAreaLayoutGuide.layoutFrame.height - 60 - heightOfnavigationBar
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ShotTableViewCell", for: indexPath)
                as? ShotTableViewCell else { return UITableViewCell() }
        
        cell.layoutCell(data: videoDataSource[indexPath.section], index: indexPath.section)
        
        cell.configureCell(videoUrl: videoDataSource[indexPath.section].url)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
}

//extension VideoViewController {
//    // MARK: - GET Videos
//    private func fetchData() {
//        
//        let videoProvider = VideoProvider()
//        videoProvider.fetchVideo(completion: { [weak self] result in
//            switch result {
//                
//            case .success(let videoData):
//                self?.videoDataSource = videoData
//                self?.tableView.reloadData()
//                self?.pausePlayeVideos()
//            case .failure:
//                print("[CameraVC] GET video失敗！")
//            }
//        })
//    }
//}
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

//                DispatchQueue.main.async {
//                    self?.collectionView.deleteItems(at: [IndexPath(row: 0, section: index)])
//                    self?.collectionView.reloadData()
//                }

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
            title: "封鎖\(userName)",
            message: "你不會再看到\(userName)的個人檔案、貼文、留言或訊息。你封鎖用戶時，對方不會收到通知。", preferredStyle: .alert)
        let blockAction = UIAlertAction(title: "封鎖", style: .destructive, handler: { (_) in
            
            self.postToBlockUser(index: index)
            //self.tableView.deleteItems(at: [IndexPath(row: 0, section: index)])
            
        })

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        blockController.addAction(blockAction)
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
