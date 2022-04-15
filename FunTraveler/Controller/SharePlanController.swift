//
//  PublishViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/15.
//

import UIKit

class PublishViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: String(describing: PlanOverViewTableViewCell.self), bundle: nil)
        
    }
    
}

extension PublishViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PlanOverViewTableViewCell.self), for: indexPath)
                as? PlanOverViewTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.dayTitle.text = "天 ｜ 旅遊回憶"
        cell.tripTitle.text = ""
        
        return cell
        
    }
    
}

