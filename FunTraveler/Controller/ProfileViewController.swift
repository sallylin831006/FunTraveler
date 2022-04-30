//
//  ProfileViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/16.
//

import UIKit

class ProfileViewController: UIViewController {
    
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
    
    private var userNameTextField: UITextField!
    
    var userId: Int?
    
    var isMyProfile: Bool = true
    
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
    
    @IBAction func logoutButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "FuntravelerToken")
        UserDefaults.standard.removeObject(forKey: "FuntravelerUserId")
        
        userData = nil
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
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        guard KeyChainManager.shared.token != nil else { return onShowLogin()  }
        
        if userId == nil && KeyChainManager.shared.userId == nil { return onShowLogin() }
        
        if isMyProfile {
            guard let userId = Int(KeyChainManager.shared.userId!) else { return }
            fetchData(userId: userId)
        } else {
            fetchData(userId: userId ?? 0)
        }
    }
    
    private func onShowLogin() {
        guard let authVC = UIStoryboard.auth.instantiateViewController(
            withIdentifier: StoryboardCategory.authVC) as? AuthViewController else { return }
        authVC.delegate = self
        let navAuthVC = UINavigationController(rootViewController: authVC)
        present(navAuthVC, animated: false, completion: nil)
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
        case 0: return 100.0
        case 1: return 70.0
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
            
            if isMyProfile {
                headerView.collectedClosure = {
                    self.fetchCollectedData()
                }
                headerView.followbutton.isHidden = true
                
                return headerView
            } else {
                headerView.segementControl.isHidden = true
                headerView.followbutton.isHidden = false
                headerView.followbutton.addTarget(self, action: #selector(tapFollowButton), for: .touchUpInside)
                
                guard let isFriend = userData?.isFriend else { return UIView()}
                if isFriend {
                    headerView.followbutton.setTitle("已追蹤", for: .normal)
                    headerView.followbutton.backgroundColor = .themeApricotDeep
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
    
    @objc func tapFollowButton() {
        postToInvite()
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
            cell.layoutCell(data: userData)
            
            let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
            cell.userImageView.addGestureRecognizer(imageTapGesture)
            cell.userImageView.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
            self.view.addGestureRecognizer(tapGesture)
            
            self.userNameTextField = cell.userNameTextField
            
            cell.changeNameDelegate = self
            cell.settingButton.addTarget(self, action: #selector(tapSettingButton), for: .touchUpInside)
            cell.numberOfFriendsButton.addTarget(self, action: #selector(tapToFriendList), for: .touchUpInside)
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ExploreOverViewTableViewCell.self), for: indexPath)
                    as? ExploreOverViewTableViewCell else { return UITableViewCell() }
            
            let item = collectedData[indexPath.row]
            cell.layoutCell(data: item)
            
            return cell
            
        default: break
            
        }
        return UITableViewCell()
        
    }
    
    @objc func tapToFriendList() {
        guard let friendListVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.friendListVC) as? FriendListViewController else { return }
        self.present(friendListVC, animated: true)
        
        //        navigationController?.pushViewController(friendListVC, animated: true)
    }
    
    @objc func tapSettingButton() {
        guard let settingVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.settingVC) as? SettingViewController else { return }
        let navSettingVC = UINavigationController(rootViewController: settingVC)
        //        navSettingVC.modalPresentationStyle = .fullScreen
        self.present(navSettingVC, animated: true)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        userNameTextField.resignFirstResponder()
        guard let name = userNameTextField.text else { return }
        patchData(name: name, image: "")
        
    }
    
    @objc func profileTapped(sender: UITapGestureRecognizer) {
        let photoSourceRequestController = UIAlertController(
            title: "", message: "選擇大頭貼照片", preferredStyle: .actionSheet)
        
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
        guard let userId = Int(KeyChainManager.shared.userId!) else { return }
        fetchData(userId: userId)
    }
}

extension ProfileViewController: ProfileTableViewCellDelegate {
    
    func didChangeName(_ cell: ProfileTableViewCell, text: String) {
            
        self.userNameTextField.text = text
        patchData(name: text, image: "")
        
    }
    
}

extension ProfileViewController {
    // MARK: - GET Action
    private func fetchData(userId: Int) {
        let userProvider = UserProvider()
        userProvider.getProfile(userId: userId, completion: { [weak self] result in
            
            switch result {
                
            case .success(let userData):
                self?.userData = userData
                self?.tableView.reloadData()
            case .failure:
                print("[ProfileVC] GET Profile 資料失敗！")
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
                print("[CollectedVC] GET 讀取資料失敗！")
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
                print("[ProfileVC] POST TO INVITE失敗！")
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
