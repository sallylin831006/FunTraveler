//
//  SettingViewConttoller.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/28.
//

import UIKit

class SettingViewController: UIViewController {
    
    private enum Setting: String {
        case deleteAccount = "刪除帳戶"
        case logOut = "登出"
        case blockList = "已封鎖的使用者"
        case privacy = "隱私權政策"
        case eula = "最終用戶許可證(EULA)"
    }
    
    private struct SettingData: Hashable {
        var content: String
    }
    
    private var settingData: [SettingData] = [ SettingData(content: Setting.deleteAccount.rawValue),
                                               SettingData(content: Setting.logOut.rawValue),
                                               SettingData(content: Setting.blockList.rawValue),
                                               SettingData(content: Setting.privacy.rawValue),
                                               SettingData(content: Setting.eula.rawValue)
    ]
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.layoutMargins = .init(top: 0.0, left: 23.5, bottom: 0.0, right: 23.5)
        tableView.separatorInset = tableView.layoutMargins
        setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        //            fetchData()
        //            tableView.reloadData()
    }
    
    func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Section Row
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        1
    //    }
    //
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "設定"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell", for: indexPath)
                as? UITableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.textLabel?.text = settingData[indexPath.row].content
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            alertUser()
        }
        if indexPath.row == 1 {
            logOut()
        }
        if indexPath.row == 2 {
            let blockListViewController = BlockListViewController()
            self.navigationController?.pushViewController(blockListViewController, animated: true)

        }
        if indexPath.row == 3 {
            let webViewController = WebViewController()
            self.navigationController?.pushViewController(webViewController, animated: true)
            webViewController.url = WebURL.privacyPolicy
            webViewController.tabBarController?.tabBar.isHidden = true

        }
        if indexPath.row == 4 {
            let webViewController = WebViewController()
            self.navigationController?.pushViewController(webViewController, animated: true)
            webViewController.url = WebURL.eula
            webViewController.tabBarController?.tabBar.isHidden = true

        }
        
        enum WebURL {
            static let privacyPolicy: String = "https://www.privacypolicies.com/live/6de37506-6a29-4eeb-b813-f150e4ca0610"
            static let eula: String = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
        }
    }
    
    func alertUser() {
        let controller = UIAlertController(title: "刪除帳戶", message: "刪除帳戶所有資料將一併消失！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default) { _ in
            self.deleteAccount()
            self.logOut()
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "FuntravelerToken")
        UserDefaults.standard.removeObject(forKey: "FuntravelerUserId")
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
//        userData = nil
//        onShowLogin()
    }
}

extension SettingViewController {
    // MARK: - DELETE USER ACCOUNT
    private func deleteAccount() {
        let userProvider = UserProvider()
        userProvider.deleteUser(completion: { result in
            
            switch result {
                
            case .success: break
                
            case .failure:
                print("[SettingVC] 刪除帳戶失敗！")
            }
        })
        
    }
}
