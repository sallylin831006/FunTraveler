//
//  AuthViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/25.
//

import UIKit
import IQKeyboardManagerSwift

protocol AuthViewControllerDelegate: AnyObject {
    func detectLoginDissmiss(_ viewController: UIViewController, _ userId: Int)
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
        ProgressHUD.show()
        userProvider.postToLogin(email: email, password: password, completion: { result in
            
            switch result {
                
            case .success(let responseData):
                ProgressHUD.showSuccess(text: "登入成功")
                let userId = responseData.userId
                self.presentingViewController?.dismiss(animated: false, completion: {
                    self.delegate?.detectLoginDissmiss(self, userId)
                })
                
            case .failure(let error):
                print(error.localizedDescription)
                ProgressHUD.showFailure(text: "登入失敗!")
            }
        })
        
    }
    
    // MARK: - Sign in with Apple
    private func siginInwithApple(appleToken: String) {
        let userProvider = UserProvider()
        ProgressHUD.show()
        userProvider.siginInwithApple(appleToken: appleToken, completion: { result in
            
            switch result {
                
            case .success(let responseData):
                ProgressHUD.showSuccess(text: "登入成功")
                let userId = responseData.userId

                self.presentingViewController?.dismiss(animated: false, completion: {
                    self.delegate?.detectLoginDissmiss(self, userId)
                })
            
            case .failure(let error):
                print(error.localizedDescription)
                ProgressHUD.showFailure(text: "登入失敗!")
            }
        })
        
    }
}
