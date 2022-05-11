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
    
    private var firstDate = Date()
    
    private var secondDate = Date()
    
    private var dayCalculateNum: Int = 0 {
        didSet {
            tableView.reloadData()
        }
    }
        
    private var titleText: String?
    
    private var currentText: String?

    
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
        
        tableView.registerCellWithNib(identifier: String(describing: AddPlanTableViewCell.self), bundle: nil)
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40
        tableView.shouldIgnoreScrollingAdjustment = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tableView.separatorStyle = .none
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
        
        cell.selectionStyle = .none
        if copyTextField == nil {
            cell.textField.text = titleText
            
        } else {
            cell.textField.text = copyTextField!
        }
        
        cell.titleDelegate = self
        
//        let datePicker = UIDatePicker()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let nowDate = formatter.string(from: datePicker.date)
//
//        self.startDate = nowDate
//        self.endDate = nowDate

        cell.departurePickerVIew.dateClosure = { [weak self] startDate, calaulateDate in
            self?.startDate = startDate
            self?.firstDate = calaulateDate
            let calendar = Calendar.current
            guard let secondDate = self?.secondDate else { return }
            let date1 = calendar.startOfDay(for: calaulateDate)
            let date2 = calendar.startOfDay(for: secondDate)

            let components = calendar.dateComponents([.day], from: date1, to: date2)
            self?.dayCalculateNum = components.day ?? 0
        }
        cell.backPickerVIew.dateClosure = { [weak self] endDate, calaulateDate in
            self?.endDate =  endDate
            self?.secondDate =  calaulateDate
            let calendar = Calendar.current
            guard let firstDate = self?.firstDate else { return }
            let date1 = calendar.startOfDay(for: firstDate)
            let date2 = calendar.startOfDay(for: calaulateDate)

            let components = calendar.dateComponents([.day], from: date1, to: date2)
            self?.dayCalculateNum = components.day ?? 0
        }
        if dayCalculateNum <= -1 {
            cell.dayCalculateLabel.text = ""
        } else {
            cell.dayCalculateLabel.text = "共 \(dayCalculateNum+1) 天"
        }
        
        
        
        return cell
        
    }
    
}

extension AddPlanViewController: FooterViewDelegate {
    func saveButton(_ saveButton: UIButton) {
        if titleText == "" {
            ProgressHUD.showFailure(text: "請輸入標題")
            return
        }
        
        let datePicker = UIDatePicker()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let nowDate = formatter.string(from: datePicker.date)
        
        if titleText == nil {
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
        
        if isCopiedTrip {
            postCopyTrip()
            dismiss(animated: true, completion: nil)
            print("成功複製行程！")
        } else {
            postData()
        }
    }
    
    func cancelButton(_ saveButton: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
                    
                    guard let planDetailViewController = self.storyboard?.instantiateViewController(
                        withIdentifier: StoryboardCategory.planDetailVC) as? PlanDetailViewController else { return }
                    
                    planDetailViewController.myTripId = tripIdResponse.id

                    self.navigationController?.pushViewController(planDetailViewController, animated: true)
                    
                case .failure:
                    ProgressHUD.showFailure(text: "上傳失敗")
                    print("tripIdResponse讀取資料失敗！")
                }
            })
            
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
                    
                case .success(let tripIdResponse):
                    ProgressHUD.showSuccess(text: "成功複製行程到行程編輯頁")
                print("copy tripIdResponse", tripIdResponse)
                    
                case .failure:
                    ProgressHUD.showFailure(text: "上傳失敗")
                    print("POST COPY TRIP 失敗！")
                }
            })
            
        }
}
