//
//  PlanOverViewViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class PlanOverViewViewController: UIViewController {
    
    private var startDateTextField: UITextField!
    
    var tripData: [TripOverView] = [] {
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        tableView.separatorStyle = .none
        tableView.registerHeaderWithNib(identifier: String(describing: HeaderView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: PlanOverViewTableViewCell.self), bundle: nil)
        
        tableView.registerFooterWithNib(identifier: String(describing: PlanCardFooterView.self), bundle: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if KeyChainManager.shared.token == nil {
            setupAlertLoginView()
            self.onShowLogin()
            return
        } else {
            alertLoginView.isHidden = true
        }
        fetchData()
    }
    
    // MARK: - Action
    private func fetchData() {
        let tripProvider = TripProvider()
        
        tripProvider.fetchTrip(completion: { result in
            
            switch result {
                
            case .success(let tripData):
                
                self.tripData = tripData
                self.tableView.reloadData()
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("GET TRIP OVERVIEW API讀取資料失敗！")
            }
        })
    }
    
    // MARK: - POST Action
    func deleteTrip(index: Int) {
        let tripProvider = TripProvider()
        let tripId = tripData[index].id
        tripProvider.deleteTrip(tripId: tripId, completion: { result in
            
            switch result {
                
            case .success:
                self.tableView.reloadData()
            case .failure:
                ProgressHUD.showFailure(text: "連線不穩")
                print("deleteTrip API讀取資料失敗！")
            }
        })
    }
    
    // MARK: - POST To Edit/Update Trip Info
    func updateTripInfo(title: String, startDate: String, endDate: String, index: Int) {
        let tripProvider = TripProvider()
        let tripId = tripData[index].id
        
        tripProvider.updateTripInfo(tripId: tripId, title: title, startDate: startDate, endDate: endDate, completion: { [weak self] result in
            
            switch result {
                
            case .success:
                ProgressHUD.showSuccess(text: "修改成功")
                self?.fetchData()
            case .failure:
                ProgressHUD.showFailure(text: "修改失敗")
                print("updateTripInfo 失敗！")
            }
        })
    }
    
    let alertLoginView = AlertLoginView()
    private func setupAlertLoginView() {
        alertLoginView.isHidden = false
        alertLoginView.alertLabel.text = "登入以編輯旅遊行程"
        alertLoginView.centerView(alertLoginView, view)
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToShowLogin))
        alertLoginView.addGestureRecognizer(imageTapGesture)
    }
    
    @objc func tapToShowLogin() {
        onShowLogin()
    }
    
}

extension PlanOverViewViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier)
                as? HeaderView else { return nil }
        
        headerView.titleLabel.text = "行程編輯"
        
        return headerView
    }
    
    // MARK: - Section Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        70.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: PlanCardFooterView.identifier)
                as? PlanCardFooterView else { return nil }
        
        footerView.scheduleButton.addTarget(target, action: #selector(tapScheduleButton), for: .touchUpInside)
        footerView.scheduleButton.setTitle("+建立行程規劃", for: .normal)
        return footerView
    }
    
    @objc func tapScheduleButton() {
        
        guard KeyChainManager.shared.token != nil else { return self.onShowLogin()  }
        
        guard let addPlanVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.addPlanVC) as? AddPlanViewController else { return }
        let navAddPlanVC = UINavigationController(rootViewController: addPlanVC)
        navAddPlanVC.modalPresentationStyle = .fullScreen
        self.present(navAddPlanVC, animated: true)
        
    }
    
    private func onShowLogin() {
        tripData = []
        guard let authVC = UIStoryboard.auth.instantiateViewController(
            withIdentifier: StoryboardCategory.authVC) as? AuthViewController else { return }
        authVC.delegate = self
        let navAuthVC = UINavigationController(rootViewController: authVC)
        present(navAuthVC, animated: true, completion: nil)
    }
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tripData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PlanOverViewTableViewCell.self), for: indexPath)
                as? PlanOverViewTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        let days = tripData[indexPath.row].days 
        cell.dayTitle.text = "\(days)天 ｜ 旅遊回憶"
        cell.tripTitle.text = tripData[indexPath.row].title

        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let planDetailViewController = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.planDetailVC) as? PlanDetailViewController else { return }

        planDetailViewController.myTripId = tripData[indexPath.row].id
      
        addChild(planDetailViewController)
        
        navigationController?.pushViewController(planDetailViewController, animated: true)
        planDetailViewController.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "刪除") { _, index in
            tableView.isEditing = false
            self.deleteTrip(index: indexPath.row)
            self.tripData.remove(at: index.row)
            
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "編輯") { _, index in
            self.showEditTextfield(index: index.row)
//            tableView.isEditing = false
//            updateTripInfo(title: String, startDate: String, endDate: String, index: Int)
            
        }
        return [deleteAction, editAction]
    }
    
    private func showEditTextfield(index: Int) {
       
        let controller = UIAlertController(title: "編輯行程資訊", message: "修改標題或天數", preferredStyle: .alert)
        controller.addTextField { titleTextField in
            titleTextField.placeholder = "修改標題"
            titleTextField.keyboardType = UIKeyboardType.default
        }
        
        controller.addTextField { startDateTextField in
            startDateTextField.placeholder = "去程日期 yyyy-MM-dd"
            startDateTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
            startDateTextField.delegate = self
        }
        
        controller.addTextField { endDateTextField in
            endDateTextField.placeholder = "回程日期 yyyy-MM-dd"
            endDateTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        }
        
        let okAction = UIAlertAction(title: "確定修改", style: .default) { [unowned controller] _ in
            let title = controller.textFields?[0].text ?? ""
            let startDate = controller.textFields?[1].text ?? ""
            let endDate = controller.textFields?[2].text ?? ""

            self.updateTripInfo(title: title, startDate: startDate, endDate: endDate, index: index)
        }
        
        
        let cancelAction = UIAlertAction(title: "取消", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        controller.addAction(cancelAction)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
   
}

extension PlanOverViewViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Format Date of Birth dd-MM-yyyy

        //initially identify your textfield

        if textField == startDateTextField {

            // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
            if (startDateTextField?.text?.count == 2) || (startDateTextField?.text?.count == 5) {
                //Handle backspace being pressed
                if !(string == "") {
                    // append the text
                    startDateTextField?.text = (startDateTextField?.text)! + "-"
                }
            }
            // check the condition not exceed 9 chars
            return !(textField.text!.count > 9 && (string.count ) > range.length)
        }
        else {
            return true
        }
    }
}



extension PlanOverViewViewController: AuthViewControllerDelegate {
    func detectLoginDissmiss(_ viewController: UIViewController, _ userId: Int) {
        if KeyChainManager.shared.token != nil {
            alertLoginView.isHidden = true
        } else {
            setupAlertLoginView()
        }
        
        fetchData()
    }
}
