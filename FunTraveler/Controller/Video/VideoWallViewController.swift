//
//  VideoWallViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/18.
//

import UIKit
import AVKit

class VideoWallViewController: UIViewController {
    
    private var videoDataSource: [Video] = []
    
    let containerView: UIView = {
        let view = UIView()
        return view }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        self.setUpUI()
        collectionView.register(UINib(nibName: String(
            describing: VideoWallHeaderView.self), bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "Header")
        
        collectionView.register(UINib(nibName: String(
            describing: VideoHeaderView.self), bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "VideoHeaderView")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .themeApricot
        fetchData()
        navigationItem.title = "動態"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.playFirstVisibleVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.playFirstVisibleVideo(false)
    }
    
    func setUpUI() {
        self.view.backgroundColor = .white
        setupContainerView()
        setupCollectionView()
        
    }
    private func showLoadingView() {
        let loadingView = LoadingView()
        view.layoutLoadingView(loadingView, view)
    }
    
}

extension VideoWallViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind
                        kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
                as? VideoWallHeaderView else { return UICollectionReusableView() }
        
        headerView.layoutHeaderView(data: videoDataSource, section: indexPath.section)
        headerView.delegate = self
        
        return headerView
        //        guard let headerView = collectionView.dequeueReusableSupplementaryView(
        //            ofKind: kind, withReuseIdentifier: "VideoHeaderView", for: indexPath)
        //                as? VideoHeaderView else { return UICollectionReusableView() }
        //
        //        return headerView
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return videoDataSource.count
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath)
                as? VideoCollectionViewCell else {  return UICollectionViewCell() }
        
        cell.configure(videoDataSource[indexPath.section].url)
        
        cell.layoutCell(data: videoDataSource[indexPath.section], index: indexPath.section)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.headerReferenceSize = CGSize(width: 0, height: 60)
        
        return CGSize(width: collectionView.frame.width, height: 600)
    }
    
}

extension VideoWallViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        playFirstVisibleVideo()
    }
    
}

extension VideoWallViewController {
    
    func playFirstVisibleVideo(_ shouldPlay: Bool = true) {
        // 1.
        let cells = collectionView.visibleCells.sorted {
            collectionView.indexPath(for: $0)?.item ?? 0 < collectionView.indexPath(for: $1)?.item ?? 0
        }
        // 2.
        let videoCells = cells.compactMap({ $0 as? VideoCollectionViewCell })
        if videoCells.count > 0 {
            // 3.
            let firstVisibileCell = videoCells.first(where: { checkVideoFrameVisibility(ofCell: $0) })
            // 4.
            for videoCell in videoCells {
                if shouldPlay && firstVisibileCell == videoCell {
                    videoCell.play()
                } else {
                    videoCell.pause()
                }
            }
        }
    }
    
    func checkVideoFrameVisibility(ofCell cell: VideoCollectionViewCell) -> Bool {
        var cellRect = cell.containerView.bounds
        cellRect = cell.containerView.convert(cell.containerView.bounds, to: collectionView.superview)
        return collectionView.frame.contains(cellRect)
    }
    
}

extension VideoWallViewController {
    // MARK: - GET Videos
    private func fetchData() {
        let videoProvider = VideoProvider()
        videoProvider.fetchVideo(completion: { [weak self] result in
            
            switch result {
                
            case .success(let videoData):
                self?.videoDataSource = videoData
                self?.collectionView.reloadData()
                
            case .failure:
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
                self?.collectionView.reloadData()
                
            case .failure:
                print("[ProfileVC] POST TO Block User失敗！")
            }
        })
    }
    
}

extension VideoWallViewController {
    func setupContainerView() {
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        
    }
    
    func setupCollectionView() {
        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive  = true
    }
    
}

extension VideoWallViewController: VideoWallHeaderViewDelegate {
    func tapToUserProfile(_ section: Int) {
        guard KeyChainManager.shared.token != nil else { return onShowLogin()  }
        guard let profileVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: StoryboardCategory.profile) as? ProfileViewController else { return }

        profileVC.userId = self.videoDataSource[section].user.id

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
            message: "\(userName)將無法再看到你的個人檔案、貼文、留言或訊息。你封鎖用戶時，對方不會收到通知。", preferredStyle: .actionSheet)
        let blockAction = UIAlertAction(title: "封鎖", style: .destructive, handler: { (_) in
            
            self.collectionView.deleteItems(at: [IndexPath(row: 0, section: index)])
            self.postToBlockUser(index: index)
            ProgressHUD.showSuccess(text: "已封鎖")
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
        present(navAuthVC, animated: false, completion: nil)
    }
   
}
