//
//  BlockListViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/4.
//

import UIKit

class BlockListViewController: UIViewController {
    
    private var blockListData: [User] = []
    
    let containerView: UIView = {
        let view = UIView()
        return view }()
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setupNavigationBar()
        setupBackButton()
        fetchData()
    }
}

extension BlockListViewController {
    // MARK: - GET Action
    private func fetchData() {
        let userProvider = UserProvider()
        userProvider.getBlockList(completion: { [weak self] result in
            
            switch result {
                
            case .success(let blockListData):
                
                self?.blockListData = blockListData.data
                self?.tableView.reloadData()
                
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
            }
        })
    }
    
    // MARK: - DELETE To unBlock User
    private func deleteToUnBlockUser(index: Int) {
        let userProvider = UserProvider()
        let userId = blockListData[index].id
        userProvider.unBlockUser(userId: userId, completion: { result in
            
            switch result {
                
            case .success:
                ProgressHUD.showSuccess(text: "解除封鎖")
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("[ProfileVC] POST TO UnBlock User失敗！")
            }
        })
    }
}

extension BlockListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "已封鎖的使用者"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        blockListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.backgroundColor = .clear
        cell.textLabel?.text = blockListData[indexPath.row].name
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addAlert(index: indexPath.row)
        
    }
    
    func addAlert(index: Int) {
        let alertController = UIAlertController(title: "解除封鎖\(blockListData[index].name)?",
                                                message: "", preferredStyle: .alert)
        
        let backAction = UIAlertAction(title: "解除封鎖", style: .destructive, handler: { (_) in
            self.deleteToUnBlockUser(index: index)
            ProgressHUD.showSuccess(text: "已解除封鎖")
            self.blockListData.remove(at: index)
            self.tableView.reloadData()
            
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        
        alertController.addAction(backAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}

extension BlockListViewController {
    func setupContainerView() {
        containerView.stickSafeArea(containerView, view)
    }
    func setupTableView() {
        self.view.backgroundColor = .themeApricot
        tableView.stickView(tableView, containerView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    func setupNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor.themeApricot
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance =
        self.navigationController?.navigationBar.standardAppearance
    }
    
    func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
}
