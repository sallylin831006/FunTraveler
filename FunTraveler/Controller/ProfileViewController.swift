//
//  ProfileViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/16.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var userData: User? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var userNameTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self

            tableView.delegate = self
            
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "FuntravelerToken")
        userData = nil
        onShowLogin()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.registerHeaderWithNib(identifier: String(describing: HeaderView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: ProfileTableViewCell.self), bundle: nil)
        movingToCollectedPage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        guard KeyChainManager.shared.token != nil else { return onShowLogin()  }
        fetchData()
    }
    
    private func onShowLogin() {
        guard let authVC = UIStoryboard.auth.instantiateViewController(
            withIdentifier: StoryboardCategory.authVC) as? AuthViewController else { return }
        authVC.delegate = self
        let navAuthVC = UINavigationController(rootViewController: authVC)
        present(navAuthVC, animated: false, completion: nil)
    }
    
    func movingToCollectedPage() {
        let collectedButton = UIButton()
        collectedButton.frame = CGRect(x: 300, y: 500, width: 70, height: 70)
        collectedButton.setBackgroundImage(UIImage.asset(.collectNormal), for: .normal)
        collectedButton.addTarget(target, action: #selector(tapCollectedButton), for: .touchUpInside)
//        self.tableView.addSubview(collectedButton)
        self.view.addSubview(collectedButton)

    }

    @objc func tapCollectedButton() {
        guard let collectedVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.collectedVC) as? CollectedViewController else { return }
        let navCollectedVC = UINavigationController(rootViewController: collectedVC)
        // navExploreDeatilVC.modalPresentationStyle = .fullScreen
        self.present(navCollectedVC, animated: true)
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UIScreen.main.bounds.width / 39 * 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier)
                as? HeaderView else { return nil }
        
        headerView.titleLabel.text = "個人"
        
        return headerView
    }
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

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
        return cell

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
//            self.showLoadingView()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                
//                imagePicker.view?.tag = view.tag
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let cameraAction = UIAlertAction(title: "相機", style: .default, handler: { (_) in
//            self.showLoadingView()
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
    func detectDissmiss(_ viewController: UIViewController) {
        fetchData()
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
    private func fetchData() {
        let userProvider = UserProvider()
        userProvider.getProfile(completion: { [weak self] result in
            
            switch result {
                
            case .success(let userData):
                self?.userData = userData.data
                self?.tableView.reloadData()
            case .failure:
                print("[ProfileVC] GET Profile 資料失敗！")
            }
        })
    }
    
    // MARK: - PATCH Action
    private func patchData(name: String, image: String) {
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
