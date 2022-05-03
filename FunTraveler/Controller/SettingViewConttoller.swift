//
//  SettingViewConttoller.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/28.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
//        tableView.registerHeaderWithNib(identifier: String(describing: HeaderView.self), bundle: nil)
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        fetchData()
//        tableView.reloadData()
//    }
      
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
//    // MARK: - Section Header
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        return 100.0
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(
//            withIdentifier: HeaderView.identifier)
//                as? HeaderView else { return nil }
//
//        headerView.titleLabel.text = "設定"
//
//        return headerView
//    }
    
    // MARK: - Section Row
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "帳戶設定"
        } else {
            return "關於"
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell", for: indexPath)
                as? UITableViewCell else { return UITableViewCell() }
        
        cell.textLabel?.text = "刪除帳戶"
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("我點了")
        alertUser()

    }
    
    func alertUser() {
        let controller = UIAlertController(title: "刪除帳戶", message: "刪除帳戶所有資料將一併消失！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default) { _ in
            self.deleteAccount()
            //也要登出
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
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
