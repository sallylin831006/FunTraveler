//
//  CommentViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/26.
//

import Foundation
import UIKit
import SwiftUI

class CommentViewController: UIViewController {
    
    var commentData: [Comment] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
        
    var tripId: Int?
    
    private var profileData: Profile?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
            tableView.dataSource = self

            tableView.delegate = self

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellWithNib(identifier: String(describing: CommentTableViewCell.self), bundle: nil)
        
        tableView.registerFooterWithNib(identifier: String(describing: CommentFooterView.self), bundle: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "留言"
        fetchData()
        fetchProfileImage() 
    }
    
}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    
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
//        headerView.titleLabel.text = "留言"
//
//        return headerView
//    }
    // MARK: - Section Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        80.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CommentFooterView.identifier)
                as? CommentFooterView else { return nil }

        if profileData == nil {
            footerView.moveToLoginButton.isHidden = false
            footerView.moveToLoginClosure = {  [weak self] in
                self?.onShowLogin()
            }
            return footerView
        } else {
            footerView.moveToLoginButton.isHidden = true
        }
        
        guard let profileData = profileData else { return UIView() }
        
        footerView.layoutFooter(data: profileData)
        footerView.sendCommentClosure = { [weak self] in
            guard let newComment = footerView.commentTextField.text else { return }
            self?.postData(content: newComment)
        
            footerView.commentTextField.text = ""
            
        }
        return footerView
    }
    
    private func onShowLogin() {
        guard let authVC = UIStoryboard.auth.instantiateViewController(
            withIdentifier: StoryboardCategory.authVC) as? AuthViewController else { return }
        let navAuthVC = UINavigationController(rootViewController: authVC)
        present(navAuthVC, animated: true, completion: nil)
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async {
            let number = self.commentData.count
            
            let indexPath = IndexPath(row: number-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CommentTableViewCell.self), for: indexPath)
                as? CommentTableViewCell else { return UITableViewCell() }
        tableView.separatorStyle = .none
        let item = commentData[indexPath.row]
        cell.layoutCell(data: item)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard KeyChainManager.shared.token != nil else {
            self.onShowLogin()
            return nil
        }
        guard let userId = KeyChainManager.shared.userId else { return nil}
        guard let userIdNumber = Int(userId) else { return nil}
        if userIdNumber == self.commentData[indexPath.row].user.id {
            let deleteAction = UIContextualAction(style: .normal, title: "刪除") { _, _, _ in
                tableView.isEditing = false
                self.deleteData(index: indexPath.row)
                self.commentData.remove(at: indexPath.row)
                
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
           
        } else {
            let blockAction = UIContextualAction(style: .destructive, title: "封鎖") { (_, _, completionHandler) in
                self.blockAction(index: indexPath.row)
                completionHandler(true)
            }
            
            let reportAction = UIContextualAction(style: .normal, title: "檢舉") { (_, _, completionHandler) in
                self.reportAction(index: indexPath.row)
                completionHandler(true)
            }

            return UISwipeActionsConfiguration(actions: [blockAction, reportAction])
        }
    }
    
    func blockAction(index: Int) {
//        let userName = commentData[index].user.name

        let blockController = UIAlertController(
            title: "封鎖用戶",
            message: "", preferredStyle: .alert)
        let blockAction = UIAlertAction(title: "封鎖此用戶", style: .destructive, handler: { (_) in
            self.postToBlockUser(index: index)
            self.deleteData(index: index)
            self.commentData.remove(at: index)
            
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        blockController.addAction(blockAction)
        blockController.addAction(cancelAction)
        present(blockController, animated: true, completion: nil)
    }
    
    func reportAction(index: Int) {
        let userName = commentData[index].user.name

        let reportController = UIAlertController(
            title: "檢舉留言",
            message: "", preferredStyle: .alert)
        let reportAction = UIAlertAction(title: "檢舉此留言", style: .destructive, handler: { (_) in
            ProgressHUD.showSuccess(text: "收到您的檢舉，團隊將在24小時盡快內處理")
            
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        reportController.addAction(reportAction)
        reportController.addAction(cancelAction)
        present(reportController, animated: true, completion: nil)
    }

}

extension CommentViewController {
    // MARK: - POST TO ADD COMMENTS
    private func postData(content: String) {
        let reactionProvider = ReactionProvider()
        guard let tripId = tripId else { return }
        reactionProvider.postToComment(content: content, tripId: tripId, completion: { result in
                
                switch result {
                    
                case .success(let responseData):
                    
                    self.commentData.append(responseData)
                    self.tableView.reloadData()
                    self.scrollToBottom()
                                    
                case .failure:
                    ProgressHUD.showFailure(text: "讀取失敗")
                    print("[CommetVC] post Comment失敗！")
                }
            })
            
        }
    
    // MARK: - DELETE COMMENTS
    private func deleteData(index: Int) {
        let reactionProvider = ReactionProvider()
        guard let tripId = tripId else { return }
        
        let commentId = commentData[index].id
        reactionProvider.deleteComment(tripId: tripId, commentId: commentId, completion: { result in
                
                switch result {
                    
                case .success: break
                                    
                case .failure:
                    ProgressHUD.showFailure(text: "讀取失敗")
                    print("[CommetVC] delete Comment失敗！")
                }
            })
            
        }
    
    // MARK: - GET Action
    private func fetchData() {
        
        let reactionProvider = ReactionProvider()
        guard let tripId = tripId else { return }
        reactionProvider.fetchComment(tripId: tripId, completion: { [weak self] result in
            
            switch result {
                
            case .success(let commentData):
                
                self?.commentData = commentData.data
                                
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("[CommentVC] GET 讀取資料失敗！")
            }
        })
    }
    
    // MARK: - GET My Profile Image
    private func fetchProfileImage() {
        let userProvider = UserProvider()
        
        guard let userId = KeyChainManager.shared.userId else { return }
        guard let userIdNumber = Int(userId) else { return }
        userProvider.getProfile(userId: userIdNumber, completion: { [weak self] result in
            
            switch result {
                
            case .success(let profileData):
                self?.profileData = profileData
                self?.tableView.reloadData()
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("[CommentVC] GET Profile 資料失敗！")
            }
        })
    }
    
    // MARK: - POST To Block User
    private func postToBlockUser(index: Int) {
        let userProvider = UserProvider()
        let userId = commentData[index].user.id
        userProvider.blockUser(userId: userId, completion: { [weak self] result in
            
            switch result {
                
            case .success(let blockResponse):
                ProgressHUD.showSuccess(text: "已封鎖")
                
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("[ProfileVC] POST TO Block User失敗！")
            }
        })
    }
}
