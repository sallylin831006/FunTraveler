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
    
    private var dayCalculateNum: Int = 0
        
    private var titleText: String?
    
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
        
        footerView.saveButton.addTarget(target, action: #selector(tapSaveButton), for: .touchUpInside)
        
        footerView.cancelButton.addTarget(target, action: #selector(tapCancelButton), for: .touchUpInside)
        
        return footerView
    }
    
    @objc func tapSaveButton() {
        if titleText == "" {
            ProgressHUD.showFailure(text: "請輸入標題")
            return
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
                    print("tripIdResponse讀取資料失敗！")
                }
            })
            
        }
  
    @objc func tapCancelButton() {
        self.dismiss(animated: true, completion: nil)
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
            cell.textField.text = ""
        } else {
            cell.textField.text = "複製 - \(copyTextField!)"
        }
        
        cell.titleDelegate = self
        
        cell.departurePickerVIew.dateClosure = { [weak self] startDate, calaulateDate in
            self?.startDate = startDate
            self?.firstDate = calaulateDate
            let calendar = Calendar.current
            guard let secondDate = self?.secondDate else { return }
            let date1 = calendar.startOfDay(for: calaulateDate)
            let date2 = calendar.startOfDay(for: secondDate)

            let components = calendar.dateComponents([.day], from: date1, to: date2)
            self?.dayCalculateNum = components.day ?? 0
            self?.tableView.reloadData()
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
            self?.tableView.reloadData()
        }
        if dayCalculateNum <= -1 {
            cell.dayCalculateLabel.text = ""
        } else {
            cell.dayCalculateLabel.text = "共 \(dayCalculateNum+1) 天"
        }
        
        
        
        return cell
        
    }
    
}

extension AddPlanViewController: AddPlanTableViewCellDelegate {
    
    func didChangeTitleData(_ cell: AddPlanTableViewCell, text: String) {
        self.titleText = text
 
    }
    
}

extension AddPlanViewController {
    // MARK: - POST API TO COPY TRIP
        private func postCopyTrip() {
            let tripProvider = TripProvider()
            let titleText = titleText ?? "複製 - "
            let startDate = startDate ?? "2022-04-27"
            let endDate = endDate ?? "2022-04-30"
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
                    print("POST COPY TRIP 失敗！")
                }
            })
            
        }
}
