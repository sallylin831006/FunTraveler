//
//  ExploreViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/15.
//

import UIKit

class ExploreViewController: UIViewController {
    
    var exploreData: [Explore] = [] {
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        tableView.reloadData()
    }
    
    // MARK: - GET Action
    private func fetchData() {
        let exploreProvider = ExploreProvider()
                
        exploreProvider.fetchExplore(completion: { [weak self] result in
            
            switch result {
                
            case .success(let exploreData):
                
                self?.exploreData = exploreData.data
                
            case .failure:
                print("[ExploreVC] GET 讀取資料失敗！")
            }
        })
    }
    
}

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier)
                as? HeaderView else { return nil }
        
        headerView.titleLabel.text = "探索"
        
        return headerView
    }
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exploreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PlanOverViewTableViewCell.self), for: indexPath)
                as? PlanOverViewTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.dayTitle.text = "\(exploreData[indexPath.row].days)天| 旅遊回憶"
        cell.tripTitle.text = exploreData[indexPath.row].title
        
        cell.userName.text = exploreData[indexPath.row].user.name
       
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let exploreDeatilVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.exploreDetailVC) as? ExploreDetailViewController else { return }
        
        exploreDeatilVC.tripId = exploreData[indexPath.row].id
        
        let navExploreDeatilVC = UINavigationController(rootViewController: exploreDeatilVC)
        // navExploreDeatilVC.modalPresentationStyle = .fullScreen
        self.present(navExploreDeatilVC, animated: true)
        
    }
    
}
