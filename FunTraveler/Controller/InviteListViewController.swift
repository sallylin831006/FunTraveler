//
//  InviteListViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/29.
//

import UIKit

class InviteListViewController: UIViewController {
    
    var inviteData: [User] = [] {
        didSet {
//            tableView.reloadData()
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
        setupSearchBar()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard KeyChainManager.shared.token != nil else {
            setupAlertLoginView()
            return
        }
        
        fetchData()
    }
    let alertLoginView = AlertLoginView()
    private func setupAlertLoginView() {
        
        alertLoginView.alertLabel.text = "登入以查看好友邀請"
        self.view.addSubview(alertLoginView)
        alertLoginView.translatesAutoresizingMaskIntoConstraints = false
        alertLoginView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertLoginView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToShowLogin))
        alertLoginView.addGestureRecognizer(imageTapGesture)
    }
    
    @objc func tapToShowLogin() {
        onShowLogin()
    }
    
    private func onShowLogin() {
        guard let authVC = UIStoryboard.auth.instantiateViewController(
            withIdentifier: StoryboardCategory.authVC) as? AuthViewController else { return }
        let navAuthVC = UINavigationController(rootViewController: authVC)
        present(navAuthVC, animated: false, completion: nil)
        alertLoginView.isHidden = true
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    private func setupSearchBar() {
        
        searchController.searchBar.placeholder = "搜尋帳戶..."
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.barTintColor = .themeRed
        searchController.searchBar.tintColor = .themeRed

        searchController.searchBar.searchTextField.backgroundColor = .themeApricot
     
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .themeRed
        textFieldInsideSearchBar?.attributedPlaceholder = NSAttributedString(string: textFieldInsideSearchBar?.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])

    }
    
    // MARK: - GET Action
    private func fetchData() {
        let friendsProvider = FriendsProvider()
        
        friendsProvider.getInviteList(completion: { [weak self] result in
            
            switch result {
                
            case .success(let inviteData):
                self?.inviteData = inviteData.data
                if inviteData.data.isEmpty {
                    let alertView = AlertLoginView()
                    alertView.alertLabel.text = "目前尚無好友邀請"
                    self?.view.addSubview(alertView)
                    alertView.translatesAutoresizingMaskIntoConstraints = false
                    alertView.centerXAnchor.constraint(equalTo: self!.view.centerXAnchor).isActive = true
                    alertView.centerYAnchor.constraint(equalTo: self!.view.centerYAnchor).isActive = true
                }
                self?.tableView.reloadData()
            case .failure:
                print("[InvitedVC] GET資料失敗！")
            }
        })
    }
    
    
    
    // MARK: - POST Action
    private func postData(index: Int, isAccept: Bool) {
        let friendsProvider = FriendsProvider()
        
        friendsProvider.postToAccept(userId: inviteData[index].id, isAccept: isAccept, completion: { [weak self] result in
            
            switch result {
                
            case .success(let postResponse):
                print("postAcceptResponse", postResponse)
                
            case .failure:
                print("[InvitedVC] GET資料失敗！")
            }
        })
    }
    
}

extension InviteListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        inviteData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: InviteListTableViewCell.self), for: indexPath)
                as? InviteListTableViewCell else { return UITableViewCell() }
        
        let item = inviteData[indexPath.row]
        cell.layoutCell(data: item, index: indexPath.row)
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let profileVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: StoryboardCategory.profile) as? ProfileViewController else { return }
        
        profileVC.userId = inviteData[indexPath.row].id
        self.present(profileVC, animated: true)
    }
}

extension InviteListViewController: InviteListTableViewCellDelegate {
    func confirmInvitation(index: Int, isAccept: Bool) {
        postData(index: index, isAccept: isAccept)
        self.inviteData.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        tableView.reloadData()
        print("已接受交友邀請！")
    }
    
    func cancelInvitation(index: Int, isAccept: Bool) {
        postData(index: index, isAccept: isAccept)
        self.inviteData.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        tableView.reloadData()
        print("已取消交友邀請！")
    }
    
}

extension InviteListViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("TextDidEndEditing")
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("SearchButtonClicked")

        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange")
//        postToSearchTrip(searchText: searchText)
//        if searchText.isEmpty {
//            fetchData()
//        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("點了取消按鈕")
//        fetchData()
    }
}
