//
//  ExploreViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/15.
//

import UIKit

class ExploreViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        setupSearchBar()
        setupNavItem()
        tableView.separatorStyle = .none
        tableView.registerHeaderWithNib(identifier: String(describing: HeaderView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: ExploreOverViewTableViewCell.self), bundle: nil)
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
//        tableView.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        } else {
            tableView.tableHeaderView = UIView(
                frame: CGRect(x: .zero, y: .zero, width: .zero, height: CGFloat.leastNonzeroMagnitude))
        }
    }
    
//    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
//        if sender.state == .began {
//            let touchPoint = sender.location(in: tableView)
//            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
//                print("我長按了")
//            }
//        }
//    }
    
    private func setupNavItem() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.friendInvitedIcon),
            style: .plain,
            target: self,
            action: #selector(tapInviteList)
        )

    }
    
    @objc func tapInviteList() {
        guard let inviteVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.inviteVC) as? InviteListViewController else { return }
        
        navigationController?.pushViewController(inviteVC, animated: true)
//        inviteVC.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupSearchBar() {
        
        searchController.searchBar.placeholder = "搜尋行程..."
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.barTintColor = .themeRed
        searchController.searchBar.tintColor = .themeRed
        searchController.searchBar.backgroundColor = .themeApricot
        searchController.searchBar.searchTextField.backgroundColor = .themeApricotDeep
     
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .themeRed
        textFieldInsideSearchBar?.attributedPlaceholder = NSAttributedString(string: textFieldInsideSearchBar?.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])

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
        cell.layoutCell(data: item)

        cell.collectClosure = { isCollected in
            self.postData(isCollected: isCollected, tripId: self.exploreData[indexPath.row].id)
            self.exploreData[indexPath.row].isCollected = isCollected
            let indexPath = IndexPath(item: indexPath.row, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        cell.heartClosure = { isLiked in
            if isLiked {
                self.postLiked(index: indexPath.row)
                self.exploreData[indexPath.row].isLiked = isLiked
                self.exploreData[indexPath.row].likeCount += 1
                tableView.reloadData()
                let indexPath = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                self.deleteLiked(index: indexPath.row)
                self.exploreData[indexPath.row].isLiked = isLiked
                self.exploreData[indexPath.row].likeCount -= 1
                let indexPath = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
           
        }
        
        cell.friendClosure = {
            
            guard let profileVC = UIStoryboard.profile.instantiateViewController(
                withIdentifier: StoryboardCategory.profile) as? ProfileViewController else { return }
            
            profileVC.userId = self.exploreData[indexPath.row].user.id
            
            if String(self.exploreData[indexPath.row].user.id) == KeyChainManager.shared.userId {
                profileVC.isMyProfile = true
            } else {
                profileVC.isMyProfile = false
            }
            self.present(profileVC, animated: true)

        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let exploreDeatilVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.exploreDetailVC) as? ExploreDetailViewController else { return }
        
        exploreDeatilVC.tripId = exploreData[indexPath.row].id
        exploreDeatilVC.days = exploreData[indexPath.row].days
        navigationController?.pushViewController(exploreDeatilVC, animated: true)
        exploreDeatilVC.tabBarController?.tabBar.isHidden = true

    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: { _ in
            
            guard let userId = KeyChainManager.shared.userId else { return nil}
            guard let userIdNumber = Int(userId) else { return nil}
            if userIdNumber == self.exploreData[indexPath.row].user.id {
                return nil
            }
            
            let blockAction =
            UIAction(title: NSLocalizedString("封鎖該使用者", comment: ""),
                     image: UIImage(systemName: "minus.circle"),
                     attributes: .destructive) { action in
                self.postToBlockUser(index: indexPath.row)
                self.exploreData.remove(at: indexPath.row)
                ProgressHUD.showSuccess(text: "")
            }
            return UIMenu(title: "", children: [blockAction])
        })
    }

}

extension ExploreViewController {
    // MARK: - POST TO ADD NEW COLLECTED
    private func postData(isCollected: Bool, tripId: Int) {
            let collectedProvider = CollectedProvider()
        
            collectedProvider.addCollected(isCollected: isCollected,
                                           tripId: tripId, completion: { result in
                
                switch result {
                    
                case .success: break
//                    print("按了收藏按鈕！", postResponse)
                                    
                case .failure:
                    print("[Explore] collected postResponse失敗！")
                }
            })
            
        }
    // MARK: - GET Action
    private func fetchData() {
        let exploreProvider = ExploreProvider()
        exploreProvider.fetchExplore(completion: { [weak self] result in
            
            switch result {
                
            case .success(let exploreData):
                
                self?.exploreData = exploreData
                
            case .failure:
                print("[ExploreVC] GET 讀取資料失敗！")
            }
        })
    }
    
    // MARK: - POST TO SEARCH TRIP
    private func postToSearchTrip(searchText: String) {
        
        let exploreProvider = ExploreProvider()
        if searchText == "" { return }
        exploreProvider.postToSearch(word: searchText, completion: { result in
            
            switch result {
                
            case .success(let searchResponse):
                self.exploreData = searchResponse
                print("searchResponse", searchResponse)
                
            case .failure:
                print("POST TO SEARCH TRIP 失敗！")
            }
        })
        
    }
    
    // MARK: - POST TO Like
    private func postLiked(index: Int) {
            let reactionProvider = ReactionProvider()
        reactionProvider.postToLiked(tripId: exploreData[index].id, completion: { result in
                
                switch result {
                    
                case .success: break
                                    
                case .failure:
                    print("[Explore] Liked postResponse失敗！")
                }
            })
            
        }
    // MARK: - DELETE TO UnLike
    private func deleteLiked(index: Int) {
            let reactionProvider = ReactionProvider()
        reactionProvider.deleteUnLiked(tripId: exploreData[index].id, completion: { result in
                
                switch result {
                    
                case .success: break
                                    
                case .failure:
                    print("[Explore] UnLiked postResponse失敗！")
                }
            })
            
        }
    // MARK: - POST To Block User
    private func postToBlockUser(index: Int) {
        let userProvider = UserProvider()
        let userId = exploreData[index].user.id
        userProvider.blockUser(userId: userId, completion: { [weak self] result in
            
            switch result {
                
            case .success:
                self?.tableView.reloadData()
                
            case .failure:
                print("[ProfileVC] POST TO Block User失敗！")
            }
        })
    }
       
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        postToSearchTrip(searchText: searchText)
        if searchText.isEmpty {
            fetchData()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchData()
    }
}
