//
//  PublishViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/15.
//

import UIKit
import IQKeyboardManagerSwift

class SharePlanViewController: UIViewController {
    
    var schedules: [Schedule] = []
    
    var imageIndex: Int?
    
    var isSimpleMode: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    var photoImageArray: [UIImageView] = []
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerHeaderWithNib(identifier: String(describing: HeaderView.self), bundle: nil)
        tableView.registerFooterWithNib(identifier: String(describing: FooterView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: ShareExperienceTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: SharePlanTableViewCell.self), bundle: nil)
        
        addSwitchButton()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40
        tableView.shouldIgnoreScrollingAdjustment = true
    }
    
    func addSwitchButton() {
        let switchButton = UIButton()
        switchButton.frame = CGRect(x: UIScreen.width-50, y: 100, width: 30, height: 30)
        switchButton.backgroundColor = .systemYellow
        switchButton.setTitle("⇋", for: .normal)
        self.view.addSubview(switchButton)
        
        switchButton.addTarget(target, action: #selector(tapSwitchButton), for: .touchUpInside)
        
    }
    
    @objc func tapSwitchButton() {
        isSimpleMode = !isSimpleMode
    }
    
}

extension SharePlanViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier)
                as? HeaderView else { return nil }
        
        headerView.titleLabel.text = "行程分享"
        
        return headerView
    }
    
    // MARK: - Section Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        150.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: FooterView.identifier)
                as? FooterView else { return nil }
        
        footerView.saveButton.addTarget(target, action: #selector(tapSaveButton), for: .touchUpInside)
        
        return footerView
    }
    @objc func tapSaveButton() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

        if let tabBarController = self.presentingViewController?.presentingViewController as? UITabBarController {
                tabBarController.selectedIndex = 0
            }
        print("已成功分享貼文！")
        // Explore Page GET API
 
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSimpleMode {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SharePlanTableViewCell.self), for: indexPath)
                    as? SharePlanTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            
            cell.orderLbael.text = String(indexPath.row+1)
            cell.nameLabel.text = schedules[indexPath.row].name
            cell.addressLabel.text = schedules[indexPath.row].address
            cell.tripTimeLabel.text = "停留時間：\(schedules[indexPath.row].duration)小時"
            
            return cell
        } else {
            guard let experienceCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ShareExperienceTableViewCell.self), for: indexPath)
                    as? ShareExperienceTableViewCell else { return UITableViewCell() }
            experienceCell.selectionStyle = .none
            
            experienceCell.orderLbael.text = String(indexPath.row+1)
            experienceCell.nameLabel.text = schedules[indexPath.row].name
            experienceCell.addressLabel.text = schedules[indexPath.row].address
            experienceCell.tripTimeLabel.text = "停留時間：\(schedules[indexPath.row].duration)小時"
            
            experienceCell.tripImage.layer.borderColor = UIColor.lightGray.cgColor
            experienceCell.tripImage.layer.borderWidth = 2
            experienceCell.tripImage.layer.cornerRadius = 10.0
            experienceCell.tripImage.layer.masksToBounds = true
            
            experienceCell.tripImage.tag = indexPath.row
            let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
            imageTapGesture.view?.tag = indexPath.row
            experienceCell.tripImage.addGestureRecognizer(imageTapGesture)
            experienceCell.tripImage.isUserInteractionEnabled = true
            
            photoImageArray.append(experienceCell.tripImage)
            return experienceCell
        }
    }
    
    @objc func profileTapped(sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        let photoSourceRequestController = UIAlertController(title: "", message: "選擇照片", preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "相簿", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                
                imagePicker.view?.tag = view.tag
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let cameraAction = UIAlertAction(title: "相機", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                
                imagePicker.view?.tag = view.tag
                
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

extension SharePlanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey: Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let photo =  photoImageArray[picker.view.tag]
            photo.image = selectedImage
            photo.contentMode = .scaleAspectFill
            photo.clipsToBounds = true
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
