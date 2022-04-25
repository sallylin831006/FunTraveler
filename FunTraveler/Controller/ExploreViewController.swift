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
        
        tableView.registerCellWithNib(identifier: String(describing: ExploreOverViewTableViewCell.self), bundle: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    // MARK: - GET Action
    private func fetchData() {
        let exploreProvider = ExploreProvider()
//        showLoadingView()
        exploreProvider.fetchExplore(completion: { [weak self] result in
            
            switch result {
                
            case .success(let exploreData):
                
                self?.exploreData = exploreData.data
                
            case .failure:
                print("[ExploreVC] GET 讀取資料失敗！")
            }
        })
    }
    
    private func showLoadingView() {
        let loadingView = LoadingView()
        view.layoutLoadingView(loadingView, view)
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
            withIdentifier: String(describing: ExploreOverViewTableViewCell.self), for: indexPath)
                as? ExploreOverViewTableViewCell else { return UITableViewCell() }
        
        let item = exploreData[indexPath.row]
        cell.layoutCell(days: item.days, tripTitle: item.title, userName: item.user.name, isCollected: item.isCollected)
        
        cell.collectClosure = { isCollected in
            self.postData(isCollected: isCollected, tripId: self.exploreData[indexPath.row].id)
            self.exploreData[indexPath.row].isCollected = isCollected
            let indexPath = IndexPath(item: indexPath.row, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        cell.heartClosure = { cell, isHeartTapped in
            if isHeartTapped {
                cell.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
                // POST API?
            } else {
                cell.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
                // POST API?
            }
            
        }
        
        cell.followClosure = { cell, isfollowed in
            
            if isfollowed {
                cell.followButton.setTitle("已追蹤", for: .selected)
                cell.followButton.setTitleColor(UIColor.themeRed, for: .selected)
                cell.followButton.layer.borderColor = UIColor.themeRed?.cgColor
                
            } else {
                cell.followButton.setTitle("追蹤", for: .normal)
                cell.followButton.setTitleColor(UIColor.themeApricotDeep, for: .normal)
                cell.followButton.layer.borderColor = UIColor.themeApricotDeep?.cgColor
                
            }
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let exploreDeatilVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.exploreDetailVC) as? ExploreDetailViewController else { return }
        
        exploreDeatilVC.tripId = exploreData[indexPath.row].id
        exploreDeatilVC.days = exploreData[indexPath.row].days

        let navExploreDeatilVC = UINavigationController(rootViewController: exploreDeatilVC)
        // navExploreDeatilVC.modalPresentationStyle = .fullScreen
        self.present(navExploreDeatilVC, animated: true)
        
    }
}

extension ExploreViewController {
    // MARK: - POST TO ADD NEW COLLECTED
    private func postData(isCollected: Bool, tripId: Int) {
            let collectedProvider = CollectedProvider()
        
            collectedProvider.addCollected(token: "mockToken", isCollected: isCollected,
                                           tripId: tripId, completion: { result in
                
                switch result {
                    
                case .success(let postResponse):
                    print("按了收藏按鈕！", postResponse)
                                    
                case .failure:
                    print("[Explore] collected postResponse失敗！")
                }
            })
            
        }
}
