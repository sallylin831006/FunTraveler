//
//  PublishViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/15.
//

import UIKit
import IQKeyboardManagerSwift

class SharePlanViewController: UIViewController {
    private let uploadImageManager = UploadImageManager()
    var schedules: [Schedule] = []
    
    var trip: Trip? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    var tripId: Int?
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSwitchButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        showLoadingView()
        fetchData(days: 1)
        
    }
    
}

extension SharePlanViewController {
    // MARK: - GET Action
    private func fetchData(days: Int) {
        let tripProvider = TripProvider()
        
        guard let tripId = tripId else { return }
        tripProvider.fetchSchedule(tripId: tripId, days: days, completion: { [weak self] result in
            
            switch result {
                
            case .success(let tripSchedule):
                
                guard let schedules = tripSchedule.data.schedules else { return }
                self?.trip = tripSchedule.data
                self?.schedules = schedules.first ?? []
                self?.tableView.reloadData()
                
            case .failure:
                ProgressHUD.showFailure()
            }
        })
        
    }
    
    // MARK: - PATCH Action
    private func patchData(isPrivate: Bool, isPublish: Bool) {
        let tripProvider = TripProvider()
        guard let tripId = tripId else { return }
        
        tripProvider.updateTrip(tripId: tripId, schedules: schedules,
                                isPrivate: isPrivate, isPublish: isPublish, completion: { [weak self] result in
            
            switch result {
                
            case .success:
                if isPublish {
                    ProgressHUD.showSuccess()
                    self?.moveToPage(tabIndex: 0)
                }
                if isPrivate {
                    ProgressHUD.showSuccess()
                    self?.moveToPage(tabIndex: 4)
                }
                
            case .failure:
                ProgressHUD.showFailure()
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
        
        headerView.layoutSharePlanHeaderView(data: trip)
        headerView.delegate = self
        
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
    @objc func tapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapSaveButton() {
        decidePublishStatus()
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
    
    private func moveToPage(tabIndex: Int) {
        
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
            
            let item = schedules[indexPath.row]
            cell.layoutCell(data: item, index: indexPath.row)
            
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
extension SharePlanViewController: ShareHeaderViewDelegate {
    func configureNumberOfButton() -> Int {
        trip?.days ?? 1
    }
    func didSelectedButton(index: Int) {
        fetchData(days: index)
    }
}

extension SharePlanViewController: ShareExperienceTableViewCellDelegate {
    
    func detectTextViewChange(_ textView: UITextView, _ index: Int) {
        schedules[index].description.append(textView.text)
        patchData(isPrivate: false, isPublish: false)
    }
    
    func detectUploadImage(_ tripImageview: UIImageView, _ imageRecognizer: UITapGestureRecognizer, _ index: Int) {
        uploadImageManager.selectImageAction(sender: imageRecognizer, viewController: self)
        uploadImageManager.tripImageView = tripImageview
        uploadImageManager.imageIndex = index
        uploadImageManager.schedules = schedules
        uploadImageManager.delegate = self
    }
    
}

extension SharePlanViewController: UploadImageManagerDelegate {
    func uploadAction() {
        patchData(isPrivate: false, isPublish: false)
        dismiss(animated: true, completion: nil)
    }
}

extension SharePlanViewController {
    private func setupTableView() {
        tableView.registerHeaderWithNib(identifier: String(describing: ShareHeaderView.self), bundle: nil)
        tableView.registerFooterWithNib(identifier: String(describing: FooterView.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: ShareExperienceTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: SharePlanTableViewCell.self), bundle: nil)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40
        tableView.shouldIgnoreScrollingAdjustment = true
    }
    
    func setupSwitchButton() {
        let switchButton = UIButton()
        self.view.addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                               constant: -16).isActive = true
        switchButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        switchButton.setBackgroundImage(UIImage(systemName: "arrow.left.arrow.right.circle"), for: .normal)
        switchButton.tintColor = UIColor.white
        switchButton.addTarget(target, action: #selector(tapSwitchButton), for: .touchUpInside)
        
    }
    
    @objc func tapSwitchButton() {
        isSimpleMode = !isSimpleMode
    }
    
    private func showLoadingView() {
        let loadingView = LoadingView()
        view.layoutLoadingView(loadingView, view)
    }
}
