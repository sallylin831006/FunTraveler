//
//  PlanOverViewViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class PlanOverViewViewController: UIViewController {
    
    var tripData: [Trip] = [] {
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
        guard KeyChainManager.shared.token != nil else {
            self.onShowLogin()
            return
        }
        fetchData()
    }
    
    // MARK: - Action
    private func fetchData() {
        let tripProvider = TripProvider()
        
        tripProvider.fetchTrip(completion: { result in
            
            switch result {
                
            case .success(let tripData):
                
                self.tripData = tripData.data
                self.tableView.reloadData()
            case .failure:
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
                print("deleteTrip API讀取資料失敗！")
            }
        })
    }
    
}

extension PlanOverViewViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 100.0
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
        present(navAuthVC, animated: false, completion: nil)
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
        return [deleteAction]
    }
    
}

extension PlanOverViewViewController: AuthViewControllerDelegate {
    func detectLoginDissmiss(_ viewController: UIViewController, _ userId: Int) {
        fetchData()
    }
}
