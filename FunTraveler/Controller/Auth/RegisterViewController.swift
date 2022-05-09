//
//  RegisterViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import UIKit
import IQKeyboardManagerSwift

class RegisterViewController: UIViewController {
    
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
        
        tableView.registerCellWithNib(identifier: String(describing: RegisterTableViewCell.self), bundle: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 200
        tableView.shouldIgnoreScrollingAdjustment = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layer.cornerRadius = 10
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        } else {
            tableView.tableHeaderView = UIView(
                frame: CGRect(x: .zero, y: .zero, width: .zero, height: CGFloat.leastNonzeroMagnitude))
        }
    }
    
}

extension RegisterViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier)
                as? HeaderView else { return nil }
        
        headerView.titleLabel.text = "註冊"
        
        return headerView
    }
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: RegisterTableViewCell.self), for: indexPath)
                as? RegisterTableViewCell else { return UITableViewCell() }

        cell.registerClosure = { [weak self] cell in
            guard let name = cell.nameTextField.text,
                  let email = cell.emailTextField.text,
                  let password = cell.passwordTextfield.text,
                  let passwordCheck = cell.passwordCheckTextfield.text else { return }
            if name == "" || email  == "" || password  == "" || passwordCheck   == "" {
                ProgressHUD.showFailure(text: "請輸入完整資料")
                return
            }
            if passwordCheck != password {
                ProgressHUD.showFailure(text: "密碼輸入不同")
                return
            }
            self?.postToRegister(email: email, password: password, name: name)
            
        }
        
        cell.cancelRegisterClosure = { [weak self] cell in
            self?.navigationController?.popViewController(animated: true)
        }
        return cell
        
    }
    
}

extension RegisterViewController {
    // MARK: - POST Register
    private func postToRegister(email: String, password: String, name: String) {
        let userProvider = UserProvider()
        
        userProvider.postToRegister(
            email: email, password: password, name: name, completion: { result in
            
            switch result {
                
            case .success:
                self.navigationController?.popViewController(animated: true)
                
            case .failure:
                ProgressHUD.showFailure(text: "註冊失敗")
                print("POST TO Register 失敗！")
            }
        })
        
    }

}
