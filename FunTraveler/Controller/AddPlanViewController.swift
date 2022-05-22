//
//  AddPlanViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit
import IQKeyboardManagerSwift

class AddPlanViewController: UIViewController, UITextFieldDelegate {
    
    var copyTripId: Int?
    
    var isCopiedTrip: Bool = false
    
    var copyTextField: String?
    
    private var startDate: String?

    private var endDate: String?
    
    private var titleText: String?
        
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

extension AddPlanViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier)
                as? HeaderView else { return nil }
        
        headerView.titleLabel.text = "建立行程"
        
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
        footerView.delegate = self
        return footerView
    }
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: AddPlanTableViewCell.self), for: indexPath)
                as? AddPlanTableViewCell else { return UITableViewCell() }
        
        if copyTextField == nil {
            cell.textField.text = titleText
        } else {
            cell.textField.text = copyTextField
        }
        
        cell.titleDelegate = self
        
        return cell
        
    }
    
}

extension AddPlanViewController: FooterViewDelegate {
    func saveButton(_ saveButton: UIButton) {
        onShowErrorMessage()
        distingushAddPlanStatus()
    }
    
    func cancelButton(_ saveButton: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func onShowErrorMessage() {
        let datePicker = UIDatePicker()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let nowDate = formatter.string(from: datePicker.date)
        
        if titleText == nil || titleText == "" {
            ProgressHUD.showFailure(text: "請輸入標題")
        }
        if startDate == nil {
            startDate = nowDate
        }
        if endDate == nil {
            endDate = nowDate
        }
        
        guard let startDate = startDate else {
            ProgressHUD.showFailure(text: "請輸入出發日期")
            return
        }
        guard let endDate = endDate else {
            ProgressHUD.showFailure(text: "請輸入回程日期")
            return
        }
        
        let isDescending = startDate.compare(endDate) == ComparisonResult.orderedDescending
        if isDescending == true {
            ProgressHUD.showFailure(text: "輸入錯誤")
            return
        }
    }
    
    private func distingushAddPlanStatus() {
        if isCopiedTrip {
            if titleText == nil {
                guard let copyTextField = copyTextField else { return }
                titleText = "複製- \(String(describing: copyTextField))"
            }
            postCopyTrip()
            dismiss(animated: true, completion: nil)
        } else {
            postData()
        }
    }
    
}

extension AddPlanViewController: AddPlanTableViewCellDelegate {
    
    func didChangeTitleData(_ cell: AddPlanTableViewCell, text: String) {
        self.titleText = text
        self.copyTextField = text
    }
}

extension AddPlanViewController {
    // MARK: - POST API TO ADD NEW TRIP
    private func postData() {
        let tripProvider = TripProvider()
        guard let titleText = titleText,
              let startDate = startDate,
              let endDate = endDate else { return }
        
        tripProvider.addTrip(title: titleText,
                             startDate: startDate,
                             endDate: endDate,
                             completion: { result in
            
            switch result {
                
            case .success(let tripIdResponse):
                movingToMapViewController(data: tripIdResponse)
                ProgressHUD.showSuccess()
            case .failure:
                ProgressHUD.showFailure()
            }
        })
        
        func movingToMapViewController(data: AddTrip) {
            guard let mapViewController = self.storyboard?.instantiateViewController(
                withIdentifier: StoryboardCategory.MapVC) as? MapViewController else { return }
            mapViewController.tripId = data.id
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
    
    // MARK: - POST API TO COPY TRIP
    private func postCopyTrip() {
        let tripProvider = TripProvider()
        guard let copyTextField = copyTextField else { return }
        let titleText = titleText ?? "複製- \(copyTextField)"
        let startDate = startDate ?? ""
        let endDate = endDate ?? ""
        guard let tripId = copyTripId else { return }
        
        tripProvider.copyTrip(title: titleText,
                              startDate: startDate,
                              endDate: endDate,
                              tripId: tripId, completion: { result in
            
            switch result {
                
            case .success:
                ProgressHUD.showSuccess(text: "成功複製行程到行程編輯頁")
                
            case .failure:
                ProgressHUD.showFailure(text: "上傳失敗")
            }
        })
        
    }
}

extension AddPlanViewController {
    private func setupTableViewUI() {
        tableView.registerHeaderWithNib(identifier: String(describing: HeaderView.self), bundle: nil)
        tableView.registerFooterWithNib(identifier: String(describing: FooterView.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: AddPlanTableViewCell.self), bundle: nil)
        tableView.shouldIgnoreScrollingAdjustment = true
        tableView.separatorStyle = .none
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40
        setupBackButton() 
    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
