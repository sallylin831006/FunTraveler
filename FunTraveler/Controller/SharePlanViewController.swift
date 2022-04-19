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
    var tripId: Int?

    private var imageString: String?
    private var stories: String?
    
    private var storiesTextViewArray: [UITextView] = []
    
    var imageIndex: Int?
    
    var isSimpleMode: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    private var daySource: [DayModel] = []
    private var days: Int = 1
    var photoImageArray: [UIImageView] = []
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.registerHeaderWithNib(identifier: String(describing: HeaderView.self), bundle: nil)
        tableView.registerHeaderWithNib(identifier: String(describing: PlanCardHeaderView.self), bundle: nil)

        tableView.registerFooterWithNib(identifier: String(describing: FooterView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: ShareExperienceTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: SharePlanTableViewCell.self), bundle: nil)
        
        addSwitchButton()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40
        tableView.shouldIgnoreScrollingAdjustment = true
        
        fetchData(days: 1)
    }
    
    // MARK: - GET Action
        private func fetchData(days: Int) {
            let tripProvider = TripProvider()

            guard let tripId = tripId else { return }
            
            var day: Int = 1
            if schedules.isEmpty {
                day = 1
            } else {
                day = schedules[0].day
            }
            
            tripProvider.fetchSchedule(tripId: tripId, days: 0, completion: { [weak self] result in
                
                switch result {
                    
                case .success(let tripSchedule):
                    
                    guard let days = tripSchedule.data.days else { return }

                    guard let schedules = tripSchedule.data.schedules else { return }

                    guard let schedule = schedules.first else { return }
                    self?.days = days
                    self?.schedules = schedule
                    self?.tableView.reloadData()
                    print("[SharePlanVC] schedules:", schedules)
                    
                case .failure:
                    print("[SharePlanVC] GET schedule Detai 讀取資料失敗！")
                }
            })
            
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
    
    // MARK: - PATCH Action
    private func patchData() {
        let tripProvider = TripProvider()
        guard let tripId = self.tripId else { return }
        
        tripProvider.updateTrip(tripId: tripId, schedules: schedules, completion: { result in

            switch result {
                
            case .success:
                print("PATCH TRIP API成功！")
                
            case .failure:
                print("PATCH TRIPAPI讀取資料失敗！")
            }
        })
    }
    
}

extension SharePlanViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 300.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: PlanCardHeaderView.identifier)
                as? PlanCardHeaderView else { return nil }
        
        headerView.departmentPickerView.isHidden = true
        headerView.titleLabel.text = "行程分享"
        headerView.selectionView.delegate = self
        headerView.selectionView.dataSource = self
        
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
        
        for (index, story) in storiesTextViewArray.enumerated() {
            schedules[index].description = story.text
        }
        print("已成功分享貼文！")
        
        let group = DispatchGroup()
        
        group.enter()
        patchData()
        group.leave()
        
        group.notify(queue: .main) { [weak self] in
            self?.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

            if let tabBarController = self?.presentingViewController as? UITabBarController {
                    tabBarController.selectedIndex = 0
                    tabBarController.tabBar.isHidden = false
                }
        }
       
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
            
            self.storiesTextViewArray.append(experienceCell.storiesTextView)
            
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
            
            guard let image = photo.image else { return }
            let newImage = image.scale(newWidth: 50.0)
            guard let imageData:NSData = newImage.pngData() as? NSData else { return }
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            
            schedules[picker.view.tag].images.removeAll()
            schedules[picker.view.tag].images.append(strBase64)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension SharePlanViewController: SelectionViewDataSource {
    
    func configureNumberOfButton(_ selectionView: SelectionView) -> Int {
        schedules.count
    }
    
    func configureDetailOfButton(_ selectionView: SelectionView) -> [DayModel] {
        return daySource
        
    }
    
    func colorOfindicator() -> UIColor { .black }
    
    func colorOfText() -> UIColor { .black }
    
}

@objc extension SharePlanViewController: SelectionViewDelegate {
    func didSelectedButton(_ selectionView: SelectionView, at index: Int) {
        fetchData(days: index)
    }
    
    func shouldSelectedButton(_ selectionView: SelectionView, at index: Int) -> Bool {
        return true
    }
}
