//
//  CommentViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/26.
//

import Foundation
import UIKit

class CommentViewController: UIViewController {
    
    var commentData: [Comment] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
        
    var tripId: Int?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
            tableView.dataSource = self

            tableView.delegate = self

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.separatorStyle = .none
        tableView.registerHeaderWithNib(identifier: String(describing: HeaderView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: CommentTableViewCell.self), bundle: nil)
        
        tableView.registerFooterWithNib(identifier: String(describing: CommentFooterView.self), bundle: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier)
                as? HeaderView else { return nil }
        
        headerView.titleLabel.text = "留言"
        
        return headerView
    }
    // MARK: - Section Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        80.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CommentFooterView.identifier)
                as? CommentFooterView else { return nil }
        
        footerView.layoutFooter()
        
        footerView.sendCommentClosure = { [weak self] in
            guard let newComment = footerView.commentTextField.text else { return }
            self?.postData(content: newComment)

//            self?.tableView.reloadData()
//            self?.scrollToBottom()
        
            footerView.commentTextField.text = ""
            
        }
        return footerView
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
        
        let item = commentData[indexPath.row]
        cell.layoutCell(data: item)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "刪除") { _, index in
            tableView.isEditing = false
            self.deleteData(index: indexPath.row)
            self.commentData.remove(at: index.row)
            
        }
        return [deleteAction]
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
                print("[CommentVC] GET 讀取資料失敗！")
            }
        })
    }
}
