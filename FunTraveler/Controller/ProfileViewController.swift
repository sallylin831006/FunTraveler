//
//  ProfileViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/16.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func detectProfileDissmiss(_ viewController: UIViewController)
}

class ProfileViewController: UIViewController {
    
    weak var delegate: ProfileViewControllerDelegate?
    
    private var collectedData: [Explore] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var collectedDataArray: [[Explore]] = []
    
    private var userData: Profile? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var profileTrips: [Trip] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var userNameTextField: UITextField!
    private var segmentedControl: UISegmentedControl!
    var userId: Int?
    
    var isMyProfile: Bool = true
    private var isMyMemory: Bool = true

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        } else {
            tableView.tableHeaderView = UIView(
                frame: CGRect(x: .zero, y: .zero, width: .zero, height: CGFloat.leastNonzeroMagnitude))
        }
    }
    
    let alertLoginView = AlertLoginView()
    private func setupAlertLoginView() {
        alertLoginView.isHidden = false
        alertLoginView.alertLabel.text = "登入以查看個人頁"
        self.view.addSubview(alertLoginView)
        alertLoginView.translatesAutoresizingMaskIntoConstraints = false
        alertLoginView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertLoginView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToShowLogin))
        alertLoginView.addGestureRecognizer(imageTapGesture)
    }
    
    @objc func tapToShowLogin() {
        onShowLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.registerHeaderWithNib(identifier: String(describing: HeaderView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: ProfileTableViewCell.self), bundle: nil)
        
        tableView.registerHeaderWithNib(identifier: String(describing: SegementView.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: ExploreOverViewTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: UnFollowTableViewCell.self), bundle: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tableView.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: animated)

        if KeyChainManager.shared.token == nil {
            setupAlertLoginView()
            onShowLogin()
        } else {
            alertLoginView.isHidden = true
        }
        
        if userId == nil && KeyChainManager.shared.userId == nil {
            setupAlertLoginView()
            onShowLogin()
            return
        }
        
        if isMyProfile {
            guard let userId = KeyChainManager.shared.userId else { return }
            guard let userIdNumber = Int(userId) else { return }
            
            fetchUserData(userId: userIdNumber)
            fetchProfileTripsData(userId: userIdNumber)
        } else {
            fetchUserData(userId: userId ?? 0)
            fetchProfileTripsData(userId: userId ?? 0)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        segmentedControl?.touchesCancelled(Set<UITouch>(), with: nil)
        segmentedControl?.selectedSegmentIndex = 0
    }
    
    private func onShowLogin() {
        tableView.isHidden = true
        guard let authVC = UIStoryboard.auth.instantiateViewController(
            withIdentifier: StoryboardCategory.authVC) as? AuthViewController else { return }
        authVC.delegate = self
        let navAuthVC = UINavigationController(rootViewController: authVC)
        present(navAuthVC, animated: true, completion: nil)
    }
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
            //        return UIScreen.main.bounds.width / 39 * 10
        case 0: return 120.0
        case 1: return 90.0
        default: break
        }
        return .zero
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: HeaderView.identifier)
                    as? HeaderView else { return nil }
            
            headerView.titleLabel.text = "個人"
            return headerView
            
        case 1:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: SegementView.identifier)
                    as? SegementView else { return nil }
            headerView.delegate = self
            if isMyProfile {
                headerView.followbutton.isHidden = true
                
                return headerView
            } else {
                headerView.segementControl.isHidden = true
                headerView.followbutton.isHidden = false
                headerView.followbutton.addTarget(self, action: #selector(tapFollowButton(_:)), for: .touchUpInside)
                
                guard let isFriend = userData?.isFriend else { return UIView()}
                guard let isInvite = userData?.isInvite else { return UIView()}
                if isFriend {
                    headerView.followbutton.setTitle("已追蹤", for: .normal)
                    headerView.followbutton.backgroundColor = .themePink
                    headerView.followbutton.isUserInteractionEnabled = false
                } else if !isFriend && isInvite {
                    headerView.followbutton.setTitle("已送出追蹤邀請", for: .normal)
                    headerView.followbutton.backgroundColor = .themePink
                    headerView.followbutton.isUserInteractionEnabled = false
                } else {
                    headerView.followbutton.setTitle("追蹤", for: .normal)
                    headerView.followbutton.addTarget(self, action: #selector(tapFollowButton), for: .touchUpInside)

                }

                return headerView
            }
            
        default: break
        }
        
        return UIView()
    }
    
    @objc func tapFollowButton(_ sender: UIButton) {
        postToInvite()
        sender.setTitle("已送出追蹤邀請", for: .normal)
        sender.backgroundColor = .themePink
        sender.isUserInteractionEnabled = false
    }
    
    // MARK: - Section Row
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return collectedData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ProfileTableViewCell.self), for: indexPath)
                    as? ProfileTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            guard let userData = userData else { return UITableViewCell()}
            cell.layoutCell(data: userData, isMyProfile: isMyProfile)
            
            if isMyProfile {
                let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
                cell.userImageView.addGestureRecognizer(imageTapGesture)
                cell.userImageView.isUserInteractionEnabled = true
                cell.settingButton.addTarget(self, action: #selector(tapSettingButton), for: .touchUpInside)

            }

            self.userNameTextField = cell.userNameTextField
            
            cell.delegate = self
            cell.numberOfFriendsButton.addTarget(self, action: #selector(tapToFriendList), for: .touchUpInside)
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ExploreOverViewTableViewCell.self), for: indexPath)
                    as? ExploreOverViewTableViewCell else { return UITableViewCell() }
            
            let item = collectedData[indexPath.row]
            cell.layoutCell(data: item)
            
            cell.collectClosure = { isCollected in
                self.postCollectedData(isCollected: isCollected, tripId: self.collectedData[indexPath.row].id, index: indexPath.row )
            }
            if isMyMemory {
                cell.collectButton.isHidden = true
            } else {
                cell.collectButton.isHidden = false
            }

            return cell
            
        default: break
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let exploreDeatilVC = UIStoryboard.explore.instantiateViewController(
            withIdentifier: StoryboardCategory.exploreDetailVC) as? ExploreDetailViewController else { return }
        switch indexPath.section {
        case 0:
            return
        case 1:
            exploreDeatilVC.tripId = collectedData[indexPath.row].id
            exploreDeatilVC.days = collectedData[indexPath.row].days
       
            setupBackButton()
            navigationController?.pushViewController(exploreDeatilVC, animated: true)
            exploreDeatilVC.tabBarController?.tabBar.isHidden = true
        default: break
        }
        
    }
    
    func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @objc func tapToFriendList() {
        guard let friendListVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.friendListVC) as? FriendListViewController else { return }
        
        friendListVC.userId = userData?.id
        self.present(friendListVC, animated: true)
        
    }
    
    @objc func tapSettingButton() {
        guard let settingVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.settingVC) as? SettingViewController else { return }
        let navSettingVC = UINavigationController(rootViewController: settingVC)
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
//    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
//        userNameTextField.resignFirstResponder()
//        guard let name = userNameTextField.text else { return }
//        patchData(name: name, image: "")
//
//    }
    
    @objc func profileTapped(sender: UITapGestureRecognizer) {
        let photoSourceRequestController = UIAlertController(
            title: "", message: "選擇大頭貼照片", preferredStyle: .alert)
        
        let photoLibraryAction = UIAlertAction(title: "相簿", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let cameraAction = UIAlertAction(title: "相機", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
        })
        
        photoSourceRequestController.addAction(photoLibraryAction)
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(cancelAction)
        
        present(photoSourceRequestController, animated: true, completion: nil)
        
    }
    
}

extension ProfileViewController: AuthViewControllerDelegate {
    func detectLoginDissmiss(_ viewController: UIViewController, _ userId: Int) {
        if KeyChainManager.shared.token != nil {
            alertLoginView.isHidden = true
        } else {
            setupAlertLoginView()
        }
        
        tableView.isHidden = false
        guard let userId = KeyChainManager.shared.userId else { return }
        guard let userIdNumber = Int(userId) else { return }
        fetchUserData(userId: userIdNumber)
        fetchProfileTripsData(userId: userIdNumber)
    }
}

extension ProfileViewController: ProfileTableViewCellDelegate {
    func blockUser(_ blockButton: UIButton) {
        let userName = userData?.name ?? "此位使用者"
        let blockController = UIAlertController(
            title: "封鎖\(userName)",
            message: "你不會再看到\(userName)的個人檔案、貼文、留言或訊息。你封鎖用戶時，對方不會收到通知。", preferredStyle: .alert)
        let blockAction = UIAlertAction(title: "封鎖", style: .destructive, handler: { (_) in
            self.postToBlockUser()
        })

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        blockController.addAction(blockAction)
        blockController.addAction(cancelAction)
        present(blockController, animated: true, completion: nil)
    }
    
    func didChangeName(_ cell: ProfileTableViewCell, text: String) {
            
        self.userNameTextField.text = text
        patchData(name: text, image: "")
        
    }
    
}

extension ProfileViewController {
    // MARK: - GET Action
    private func fetchUserData(userId: Int) {
        let userProvider = UserProvider()
        userProvider.getProfile(userId: userId, completion: { [weak self] result in
            
            switch result {
                
            case .success(let userData):
                self?.userData = userData
                self?.tableView.reloadData()
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("[ProfileVC] GET Profile 資料失敗！")
            }
        })
    }
    
    // MARK: - GET PROFILE PUBLIC/PRIVATE TRIPS
    private func fetchProfileTripsData(userId: Int) {
        let userProvider = UserProvider()
        userProvider.getProfileTrips(userId: userId, completion: { [weak self] result in
            
            switch result {
                
            case .success(let profileTripsData):
                self?.collectedData = profileTripsData.data
                self?.tableView.reloadData()
            case .failure:
                print("[ProfileVC] GET Profile Trips 資料失敗！")
            }
        })
    }
    
    // MARK: - PATCH Action
    private func patchData(name: String, image: String) {
        
        guard let isFriend = userData?.isFriend else { return }
        if isFriend { return }
        
        let userProvider = UserProvider()
        userProvider.updateProfile(name: name, image: image, completion: { result in
            
            switch result {
                
            case .success(let updateData):
                
                self.userData?.imageUrl = updateData.data.imageUrl
                self.userData?.name = updateData.data.name
                
                self.tableView.reloadData()
                
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("PATCH Profile失敗！")
            }
        })
    }
    
    // MARK: - GET Collected Page
    private func fetchCollectedData() {
        let exploreProvider = CollectedProvider()
        
        exploreProvider.fetchCollected(completion: { [weak self] result in
            
            switch result {
                
            case .success(let collectedData):
                
                self?.collectedData = collectedData.data
                self?.collectedDataArray.append(self!.collectedData)
                self?.tableView.reloadData()
                
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("[ProfileVC] GET 讀取資料失敗！")
            }
        })
    }
    
    // MARK: - POST TO ADJUST COLLECTED status
    private func postCollectedData(isCollected: Bool, tripId: Int, index: Int) {
            let collectedProvider = CollectedProvider()
        
            collectedProvider.addCollected(isCollected: isCollected,
                                           tripId: tripId, completion: { result in
                
                switch result {
                    
                case .success:
                    ProgressHUD.showSuccess()
                    self.collectedData.remove(at: index)
                    self.tableView.reloadData()
                                    
                case .failure:
                    ProgressHUD.showFailure(text: "讀取失敗")
                    print("[Explore] collected postResponse失敗！")
                }
            })
            
        }
 
    // MARK: - POST TO INVITE
    private func postToInvite() {
        let friendsProvider = FriendsProvider()
        guard let userId = userId else { return }
        friendsProvider.postToInvite(userId: userId, completion: { [weak self] result in
            
            switch result {
                
            case .success(let postResponse):
                print("postResponse", postResponse)
                
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("[ProfileVC] POST TO INVITE失敗！")
            }
        })
    }
    
    // MARK: - POST To Block User
    private func postToBlockUser() {
        let userProvider = UserProvider()
        guard let userId = userId else { return }
        userProvider.blockUser(userId: userId, completion: { [weak self] result in
            
            switch result {
                
            case .success:
                ProgressHUD.showSuccess(text: "已封鎖")
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                    self?.delegate?.detectProfileDissmiss(self!)
                }
                
            case .failure:
                ProgressHUD.showFailure(text: "封鎖失敗，請再次嘗試")
                print("[ProfileVC] POST TO Block User失敗！")
            }
        })
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey: Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let newImage = selectedImage.scale(newWidth: 100.0)
            guard let imageData: NSData = newImage.jpegData(compressionQuality: 1) as NSData? else { return }
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            
            patchData(name: "", image: strBase64)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension ProfileViewController: SegementViewDelegate {
    func switchSegement(_ segmentedControl: UISegmentedControl) {
        self.segmentedControl = segmentedControl
        if segmentedControl.selectedSegmentIndex == 0 {
            isMyMemory = true
            guard let userId = KeyChainManager.shared.userId else { return }
            guard let userIdNumber = Int(userId) else { return }
            fetchProfileTripsData(userId: userIdNumber)
          
        } else if segmentedControl.selectedSegmentIndex == 1 {
            isMyMemory = false
            fetchCollectedData()
            
        }
        
    }
    
}
