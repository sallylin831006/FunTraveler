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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.registerHeaderWithNib(identifier: String(describing: HeaderView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: PlanOverViewTableViewCell.self), bundle: nil)
        
        tableView.registerFooterWithNib(identifier: String(describing: PlanCardFooterView.self), bundle: nil)
        fetchData()
    }
    
    // MARK: - Action
    private func fetchData() {
        let tripProvider = TripProvider()
        
        tripProvider.fetchTrip(completion: { result in
            
            switch result {
                
            case .success(let tripData):
                
                self.tripData = tripData.data
                
            case .failure:
                print("GET TRIP OVERVIEW API讀取資料失敗！")
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
        
        headerView.titleLabel.text = "行程總覽"
        
        return headerView
    }
    
    // MARK: - Section Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        50.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: PlanCardFooterView.identifier)
                as? PlanCardFooterView else { return nil }
        
        footerView.scheduleButton.addTarget(target, action: #selector(tapScheduleButton), for: .touchUpInside)
        
        return footerView
    }
    
    @objc func tapScheduleButton() {
        
        guard let addPlanVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.addPlanVC) as? AddPlanViewController else { return }
        let navAddPlanVC = UINavigationController(rootViewController: addPlanVC)
        navAddPlanVC.modalPresentationStyle = .fullScreen
        self.present(navAddPlanVC, animated: true)
        
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
        //guard let days = tripData[indexPath.row].days else { return UITableViewCell() }
        let days = tripData[indexPath.row].days ?? 0
        cell.dayTitle.text = "\(days)天 ｜ 旅遊回憶"
        cell.tripTitle.text = tripData[indexPath.row].title
        
        cell.planImageView.layer.borderColor = UIColor.themeApricotDeep?.cgColor
        cell.planImageView.layer.borderWidth = 3
        cell.planImageView.layer.cornerRadius = 10.0
        cell.planImageView.layer.masksToBounds = true
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let planDetailViewController = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.planDetailVC) as? PlanDetailViewController else { return }
        
        //透過只要傳tripId進去，到detail頁面再傳給picker就可以
        print("[PlanOverView] 我的tripId",tripData[indexPath.row].id)
        
        planDetailViewController.tripId = tripData[indexPath.row].id
        print("[PlanOverView] tripData[indexPath.row].id:",tripData[indexPath.row].id)
        print("[PlanOverView] planDetailViewController.tripId",planDetailViewController.tripId)
        addChild(planDetailViewController)
        //view.addSubview(planDetailViewController.view)
        
        navigationController?.pushViewController(planDetailViewController, animated: true)
        planDetailViewController.tabBarController?.tabBar.isHidden = true
    }
    
}
