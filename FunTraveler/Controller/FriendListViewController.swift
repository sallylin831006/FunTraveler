//
//  FriendListViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/29.
//

import UIKit

protocol FriendListViewControllerDelegate: AnyObject {
    func passingCoEditFriendsData( _ friendListData: User)
    
    func removeCoEditFriendsData( _ friendListData: User, _ index: Int)
}

class FriendListViewController: UIViewController {
    
    weak var delegate: FriendListViewControllerDelegate?
    
    var friendListData: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var isEditMode: Bool = false
    
    var userId: Int?
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - GET Friends List
    private func fetchData() {
        let friendsProvider = FriendsProvider()
        guard let userId = userId else { return }
        
        friendsProvider.getFriendList(userId: userId, completion: { [weak self] result in
            
            switch result {
                
            case .success(let friendListData):
                
                self?.friendListData = friendListData.data
                
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("[FriendVC] GET 讀取資料失敗！")
            }
        })
    }
    
}

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isEditMode {
            return "新增好友以共同編輯"
        } else {
            return "好友列表"
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isEditMode {
            
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    self.delegate?.removeCoEditFriendsData(friendListData[indexPath.row], indexPath.row)
                } else {
                    self.delegate?.passingCoEditFriendsData(friendListData[indexPath.row])
                    cell.accessoryType = .checkmark
                    cell.tintColor = .themeRed
                }
            }
            
            return
            
        } else {
            
            guard let profileVC = UIStoryboard.profile.instantiateViewController(
                withIdentifier: StoryboardCategory.profile) as? ProfileViewController else { return }
            
            profileVC.userId = friendListData[indexPath.row].id
            
            profileVC.isMyProfile = false
            self.present(profileVC, animated: true)
            
        }
        
    }
}

extension FriendListViewController {
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.registerCellWithNib(identifier: String(describing: InviteListTableViewCell.self), bundle: nil)
    }
}
