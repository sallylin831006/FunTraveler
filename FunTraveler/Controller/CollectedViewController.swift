//
//  CollectedViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/20.
//

import UIKit

class CollectedViewController: UIViewController {
    
    var collectedData: [Explore] = [] {
        didSet {
//            tableView.reloadData()
        }
    }
    
    var collectedDataArray: [[Explore]] = []

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
    }
    
    // MARK: - GET Action
    private func fetchData() {
        let exploreProvider = CollectedProvider()
        
        exploreProvider.fetchCollected(completion: { [weak self] result in
            
            switch result {
                
            case .success(let collectedData):
                
                self?.collectedData = collectedData.data
//                guard let collectedData = collectedData.data else{ return }
                self?.collectedDataArray.append(self!.collectedData)
                self?.tableView.reloadData()
                print("collectedData.data", collectedData.data)
                
            case .failure:
                print("[CollectedVC] GET 讀取資料失敗！")
            }
        })
    }
    
}

extension CollectedViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier)
                as? HeaderView else { return nil }
        
        headerView.titleLabel.text = "收藏"
        
        return headerView
    }
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collectedData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ExploreOverViewTableViewCell.self), for: indexPath)
                as? ExploreOverViewTableViewCell else { return UITableViewCell() }
        
        let item = collectedData[indexPath.row]
//        cell.layoutCell(days: item.days, tripTitle: item.title, userName: item.user.name, isCollected: item.isCollected)
        cell.layoutCell(data: item)
        
        cell.collectButton.setImage(UIImage.asset(.collectSelected), for: .normal) //不太好的做法
        cell.collectClosure = { isCollected in
            print("取消蒐藏", isCollected)
            self.postData(isCollected: item.isCollected, tripId: self.collectedData[indexPath.row].id)
            self.collectedData.remove(at: indexPath.row)
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .left)
            tableView.reloadData()
            
        }
        
        cell.heartClosure = { isHeartTapped in
            
            if isHeartTapped {
                cell.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
                // POST API?
            } else {
                cell.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
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
//        guard let exploreDeatilVC = storyboard?.instantiateViewController(
//            withIdentifier: StoryboardCategory.exploreDetailVC) as? ExploreDetailViewController else { return }
//
//        exploreDeatilVC.tripId = exploreData[indexPath.row].id
//
//        let navExploreDeatilVC = UINavigationController(rootViewController: exploreDeatilVC)
//        // navExploreDeatilVC.modalPresentationStyle = .fullScreen
//        self.present(navExploreDeatilVC, animated: true)
        
    }
}

extension CollectedViewController {
    // MARK: - POST TO ADJUST COLLECTED status
    private func postData(isCollected: Bool, tripId: Int) {
            let collectedProvider = CollectedProvider()
        
            collectedProvider.addCollected( isCollected: isCollected,
                                           tripId: tripId, completion: { result in
                
                switch result {
                    
                case .success(let postResponse):
                    print("已取消收藏～", postResponse)
                                    
                case .failure:
                    print("[Explore] collected postResponse失敗！")
                }
            })
            
        }
}
