//
//  FriendListViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/29.
//

import UIKit

class FriendListViewController: UIViewController {
    
    var friendListData: [User] = [] {
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
        tableView.registerCellWithNib(identifier: String(describing: InviteListTableViewCell.self), bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - GET Friends List
    private func fetchData() {
        let friendsProvider = FriendsProvider()
        
        friendsProvider.getFriendList(completion: { [weak self] result in
            
            switch result {
                
            case .success(let friendListData):
                
                self?.friendListData = friendListData.data
                
            case .failure:
                print("[FriendVC] GET 讀取資料失敗！")
            }
        })
    }
    
}

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendListData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: InviteListTableViewCell.self), for: indexPath)
                as? InviteListTableViewCell else { return UITableViewCell() }
        
        let item = friendListData[indexPath.row]
        cell.layoutCell(data: item, index: indexPath.row)
        
        cell.confirmInviteButton.isHidden = true
        cell.cancelInviteButton.isHidden = true
        
        //        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let profileVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: StoryboardCategory.profile) as? ProfileViewController else { return }
        
        profileVC.userId = friendListData[indexPath.row].id
        self.present(profileVC, animated: true)
    }
}
