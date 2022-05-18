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
    
    var trip: Trip? {
        didSet {
            tableView?.reloadData()
        }
    }
    var myTripId: Int?
    
    private var tripImage: UIImageView?
    private var imageIndex: Int = 0
    private var isSimpleMode: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        showLoadingView()
        fetchData(days: 1)
    }
    private func showLoadingView() {
        let loadingView = LoadingView()
        view.layoutLoadingView(loadingView, view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerHeaderWithNib(identifier: String(describing: ShareHeaderView.self), bundle: nil)
        
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
    
    // MARK: - GET Action
    private func fetchData(days: Int) {
        let tripProvider = TripProvider()
        
        guard let tripId = myTripId else { return }
        tripProvider.fetchSchedule(tripId: tripId, days: days, completion: { [weak self] result in
            
            switch result {
                
            case .success(let tripSchedule):
                
                guard let schedules = tripSchedule.data.schedules else { return }
                self?.trip = tripSchedule.data
                self?.schedules = schedules.first ?? []
                self?.tableView.reloadData()
                
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("[SharePlanVC] GET schedule Detai 讀取資料失敗！")
            }
        })
        
    }
    
    func addSwitchButton() {
        let switchButton = UIButton()
        switchButton.frame = CGRect(x: UIScreen.width-55, y: 70, width: 40, height: 40)
        switchButton.setBackgroundImage(UIImage(systemName: "arrow.left.arrow.right.circle"), for: .normal)
        switchButton.tintColor = UIColor.white
        self.view.addSubview(switchButton)
        
        switchButton.addTarget(target, action: #selector(tapSwitchButton), for: .touchUpInside)
        
    }
    
    @objc func tapSwitchButton() {
        isSimpleMode = !isSimpleMode
    }
    
    // MARK: - PATCH Action
    private func patchData(isPrivate: Bool, isPublish: Bool) {
        let tripProvider = TripProvider()
        guard let tripId = myTripId else { return }
        
        tripProvider.updateTrip(tripId: tripId, schedules: schedules,
                                isPrivate: isPrivate, isPublish: isPublish, completion: { [weak self] result in
            
            switch result {
                
            case .success:
                if isPublish {
                    ProgressHUD.showSuccess(text: "成功發布貼文")
                    self?.moveToPage(tabIndex: 0)
                }
                if isPrivate {
                    ProgressHUD.showSuccess(text: "成功發布私密貼文")
                    self?.moveToPage(tabIndex: 4)
                }
               
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("PATCH TRIPAPI讀取資料失敗！")
            }
        })
    }
    
}

extension SharePlanViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ShareHeaderView.identifier)
                as? ShareHeaderView else { return nil }
        guard let trip = trip else { return nil }
        headerView.titleLabel.text = trip.title
        headerView.dateLabel.text = "\(trip.startDate!) - \(trip.endDate!)"

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
        
        footerView.cancelButton.addTarget(target, action: #selector(tapCancelButton), for: .touchUpInside)
        
        return footerView
    }
    @objc func tapSaveButton() {
        decidePublishStatus()
    }
    
    @objc func tapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func decidePublishStatus() {
        let publishController = UIAlertController(title: "確定發文?", message: "選擇發文狀態", preferredStyle: .actionSheet)
        let publicAction = UIAlertAction(title: "公開", style: .default, handler: { (_) in
            self.patchData(isPrivate: false, isPublish: true)
        })
        let privateAction = UIAlertAction(title: "私密", style: .default, handler: { (_) in
            self.patchData(isPrivate: true, isPublish: true)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        publishController.addAction(publicAction)
        publishController.addAction(privateAction)
        publishController.addAction(cancelAction)
        present(publishController, animated: true, completion: nil)
    }
    
    func moveToPage(tabIndex: Int) {
        
        if self.presentingViewController?.presentingViewController == nil {
            dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            if let tabBarController = self.presentingViewController as? UITabBarController {
                tabBarController.selectedIndex = tabIndex
                tabBarController.tabBar.isHidden = false
            }
        } else {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            if let tabBarController = self.presentingViewController?.presentingViewController as? UITabBarController {
                tabBarController.selectedIndex = tabIndex
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
            
            let item = schedules[indexPath.row]
            experienceCell.layoutCell(data: item, index: indexPath.row)
            experienceCell.delegate = self
            
            if schedules[indexPath.row].name.isEmpty { return UITableViewCell() }

            return experienceCell
        }
    }

}

extension SharePlanViewController: SegmentControlViewDataSource {
    
    func configureNumberOfButton(_ selectionView: SegmentControlView) -> Int {
        trip?.days ?? 1
    }
    
}

@objc extension SharePlanViewController: SegmentControlViewDelegate {
    func didSelectedButton(_ selectionView: SegmentControlView, at index: Int) {
        fetchData(days: index)
    }

}
extension SharePlanViewController: ShareExperienceTableViewCellDelegate {
    
    func detectTextViewChange(_ textView: UITextView, _ index: Int) {
        schedules[index].description.append(textView.text)
        patchData(isPrivate: false, isPublish: false)
    }
    
    func detectUploadImage(_ tripImage: UIImageView, _ imageRecognizer: UITapGestureRecognizer, _ index: Int) {
        selectImageAction(sender: imageRecognizer)
        self.tripImage = tripImage
        self.imageIndex = index

    }
    
    func selectImageAction(sender: UITapGestureRecognizer) {
//        guard let view = sender.view else { return }
        let photoSourceRequestController = UIAlertController(title: "", message: "選擇照片", preferredStyle: .alert)
        
        let photoLibraryAction = UIAlertAction(title: "相簿", style: .default, handler: { (_) in
            self.showLoadingView()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
//        let cameraAction = UIAlertAction(title: "相機", style: .default, handler: { (_) in
//            self.showLoadingView()
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                let imagePicker = UIImagePickerController()
//                imagePicker.allowsEditing = true
//                imagePicker.sourceType = .camera
//                imagePicker.delegate = self
//
//                self.present(imagePicker, animated: true, completion: nil)
//            }
//        })

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
        })
        
        photoSourceRequestController.addAction(photoLibraryAction)
//        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(cancelAction)
        
        // iPad specific code
        photoSourceRequestController.popoverPresentationController?.sourceView = self.view
        
        let xOrigin = self.view.bounds.width / 2
        
        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
        
        photoSourceRequestController.popoverPresentationController?.sourceRect = popoverRect
        
        photoSourceRequestController.popoverPresentationController?.permittedArrowDirections = .up
        
        present(photoSourceRequestController, animated: true, completion: nil)

        
    }
}

extension SharePlanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey: Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            tripImage?.image = selectedImage
            tripImage?.contentMode = .scaleAspectFill
            tripImage?.clipsToBounds = true
            
        guard let image = tripImage?.image else { return }
        let newImage = image.scale(newWidth: 100.0)
        guard let imageData: NSData = newImage.jpegData(compressionQuality: 1) as NSData? else { return }
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            
        schedules[imageIndex].images.append(strBase64)
        patchData(isPrivate: false, isPublish: false)

        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
