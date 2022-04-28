//
//  AuthViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import UIKit
import IQKeyboardManagerSwift

protocol AuthViewControllerDelegate: AnyObject {
    func detectDissmiss(_ viewController: UIViewController, _ userId: Int)
}

class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?

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
        
        tableView.registerCellWithNib(identifier: String(describing: AuthTableViewCell.self), bundle: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tableView.reloadData()
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 200
        tableView.shouldIgnoreScrollingAdjustment = true
    }

}

extension AuthViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier)
                as? HeaderView else { return nil }
        
        headerView.titleLabel.text = "登入"
        
        return headerView
    }
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: AuthTableViewCell.self), for: indexPath)
                as? AuthTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.loginClosure = { [weak self] cell in
            guard let email = cell.emailTextField.text,
                  let password = cell.passwordTextField.text else { return }
            self?.postToLogin(email: email, password: password)
        }
    
        cell.siginInwithAppleClosure = { [weak self] appleToken in
            self?.siginInwithApple(appleToken: appleToken)
            
        }
        
        cell.moveToRegisterButton.addTarget(self, action: #selector(tapMoveToRegisterButton), for: .touchUpInside)
        return cell
        
    }
    
    @objc func tapMoveToRegisterButton() {
        guard let registerVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.registerVC) as? RegisterViewController else { return }
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
}

extension AuthViewController {
    // MARK: - POST To Login
    private func postToLogin(email: String, password: String) {
        let userProvider = UserProvider()
        
        userProvider.postToLogin(email: email, password: password, completion: { result in
            
            switch result {
                
            case .success(let responseData):
                let userId = responseData.userId
                self.presentingViewController?.dismiss(animated: false, completion: {
                    self.delegate?.detectDissmiss(self, userId)
                })
                
            case .failure(let error):
                print("POST TO Login 失敗！\(error)")
            }
        })
        
    }
    
    // MARK: - Sign in with Apple
    private func siginInwithApple(appleToken: String) {
        let userProvider = UserProvider()
        
        userProvider.siginInwithApple(appleToken: appleToken, completion: { result in
            
            switch result {
                
            case .success(let responseData):
                let userId = responseData.userId

                self.presentingViewController?.dismiss(animated: false, completion: {
                    self.delegate?.detectDissmiss(self, userId)
                })
                
            case .failure(let error):
                print("Sign in with Apple失敗！\(error)")
            }
        })
        
    }
}
