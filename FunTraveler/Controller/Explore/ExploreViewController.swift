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
    private let alertView = AlertLoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        fetchData()
    }
    
    @objc func tapInviteList() {
        guard let inviteVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.inviteVC) as? InviteListViewController else { return }
        navigationController?.pushViewController(inviteVC, animated: true)
    }
}

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exploreData.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        if KeyChainManager.shared.token == nil {
            cell.heartButton.setImage(UIImage.asset(.heartNormal), for: .selected)
        }
        cell.heartClosure = { isLiked in
            guard KeyChainManager.shared.token != nil else { self.onShowLogin() return }
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
            let navProfileVC = UINavigationController(rootViewController: profileVC)
            
            profileVC.userId = self.exploreData[indexPath.row].user.id
            profileVC.delegate = self
            if String(self.exploreData[indexPath.row].user.id) == KeyChainManager.shared.userId {
                profileVC.isMyProfile = true
            } else {
                profileVC.isMyProfile = false
            }
            self.present(navProfileVC, animated: true)
            
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
            guard KeyChainManager.shared.token != nil else {
                self.onShowLogin()
                return nil
            }
            guard let userId = KeyChainManager.shared.userId else { return nil}
            guard let userIdNumber = Int(userId) else { return nil}
            if userIdNumber == self.exploreData[indexPath.row].user.id {
                return nil
            }
            
            let blockAction =
            UIAction(title: NSLocalizedString("封鎖該使用者", comment: ""),
                     image: UIImage(systemName: "minus.circle"),
                     attributes: .destructive) { _ in
                self.postToBlockUser(index: indexPath.row)
                self.exploreData.remove(at: indexPath.row)
                ProgressHUD.showSuccess(text: "已封鎖")
            }
            
            let reportAction =
            UIAction(title: NSLocalizedString("檢舉此貼文", comment: ""),
                     image: UIImage(systemName: "minus.circle"),
                     attributes: .destructive) { _ in
                ProgressHUD.showSuccess(text: "收到您的檢舉，團隊將在24小時盡快內處理")
            }
            
            let blockAndReportAction =
            UIAction(title: NSLocalizedString("封鎖並檢舉此貼文", comment: ""),
                     image: UIImage(systemName: "minus.circle"),
                     attributes: .destructive) { _ in
                self.postToBlockUser(index: indexPath.row)
                self.exploreData.remove(at: indexPath.row)
                ProgressHUD.showSuccess(text: "已封鎖該用戶，且團隊將在24小時盡快內處理您的檢舉")
            }
            
            return UIMenu(title: "", children: [blockAction, reportAction, blockAndReportAction])
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
                
            case .failure:
                ProgressHUD.showFailure()
            }
        })
        
    }
    // MARK: - GET Action
    private func fetchData() {
        ProgressHUD.show()
        let exploreProvider = ExploreProvider()
        exploreProvider.fetchExplore(completion: { [weak self] result in
            ProgressHUD.dismiss()
            switch result {
                
            case .success(let exploreData):
                self?.exploreData = exploreData
                self?.tableView.reloadData()
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
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
                if searchResponse.isEmpty {
                    self.setupAlertView()
                }
                
            case .failure:
                //                ProgressHUD.showFailure()
                print("POST TO SEARCH TRIP 失敗！")
            }
        })
        
    }
    private func setupAlertView() {
        alertView.isHidden = false
        alertView.alertLabel.text = "查無資料"
        
        alertView.centerView(alertView, view)
    }
    
    // MARK: - POST TO Like
    private func postLiked(index: Int) {
        let reactionProvider = ReactionProvider()
        reactionProvider.postToLiked(tripId: exploreData[index].id, completion: { result in
            
            switch result {
                
            case .success: break
                
            case .failure:
                ProgressHUD.showFailure(text: "按讚失敗")
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
                ProgressHUD.showFailure()
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
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                ProgressHUD.showSuccess()
                
            case .failure:
                ProgressHUD.showFailure(text: "封鎖失敗，請再次嘗試")
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
            alertView.isHidden = true
            fetchData()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        alertView.isHidden = true
        fetchData()
    }
}

extension ExploreViewController: ProfileViewControllerDelegate {
    func detectProfileDissmiss(_ viewController: UIViewController) {
        fetchData()
    }
    
}

extension ExploreViewController {
    
    private func setupUI() {
        setupSearchBar()
        setupNavItem()
        setupTableViewUI()
    }
    
    private func setupTableViewUI() {
        self.tabBarController?.tabBar.isHidden = false
        tableView.separatorStyle = .none
        tableView.registerCellWithNib(identifier: String(describing: ExploreOverViewTableViewCell.self), bundle: nil)
    }
    
    private func setupNavItem() {
        addLogoToNavigationBarItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.friendInvitedIcon),
            style: .plain,
            target: self,
            action: #selector(tapInviteList)
        )
    }
    
    private func addLogoToNavigationBarItem() {
        let imageView = UIImageView(image: UIImage.asset(.logo))
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        self.navigationItem.titleView = imageView
    }
    
    private func setupSearchBar() {
        searchController.searchBar.placeholder = "搜尋行程..."
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.backgroundColor = .themeApricot
        navigationController?.navigationBar.barTintColor = .themeApricot
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.barTintColor = .themeRed
        searchController.searchBar.tintColor = .themeRed
        searchController.searchBar.backgroundColor = .themeApricot
        searchController.searchBar.searchTextField.backgroundColor = .themeApricot
        
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .themeRed
        textFieldInsideSearchBar?.attributedPlaceholder =
        NSAttributedString(string: textFieldInsideSearchBar?.placeholder ?? "",
                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
    }
    
    private func showLoadingView() {
        let loadingView = LoadingView()
        view.layoutLoadingView(loadingView, view)
    }
    
    private func onShowLogin() {
        guard let authVC = UIStoryboard.auth.instantiateViewController(
            withIdentifier: StoryboardCategory.authVC) as? AuthViewController else { return }
        let navAuthVC = UINavigationController(rootViewController: authVC)
        present(navAuthVC, animated: true, completion: nil)
    }
    
}
