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
        addCustomBackButton()
    }
    
    private func addCustomBackButton() {
        let customBackButton = UIButton()
        customBackButton.frame = CGRect(x: 20, y: 350, width: 30, height: 30)
        customBackButton.setBackgroundImage(UIImage(systemName: "chevron.backward"), for: .normal)
        customBackButton.tintColor = .white
        customBackButton.backgroundColor = .systemYellow
        customBackButton.addTarget(self, action: #selector(backTap), for: .touchUpInside)
        self.view.addSubview(customBackButton)
    }
    
    @objc func backTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)        
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
        cell.selectionStyle = .none
        cell.registerClosure = { [weak self] cell in
            guard let name = cell.nameTextField.text,
                  let email = cell.emailTextField.text,
                  let password = cell.passwordTextfield.text,
                  let passwordCheck = cell.passwordCheckTextfield.text else { return }
            if passwordCheck != password {
                print("密碼確認錯誤，請再次確認！")
                return
            }
            self?.postToRegister(email: email, password: password, name: name)
            self?.presentingViewController?.dismiss(animated: false, completion: nil)
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
                
            case .success: break
                
            case .failure:
                print("POST TO Register 失敗！")
            }
        })
        
    }

}
