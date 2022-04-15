//
//  PublishViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/15.
//

import UIKit

class SharePlanViewController: UIViewController {
    
    var schedules: [Schedule] = []

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: String(describing: SharePlanTableViewCell.self), bundle: nil)
    }
    
}

extension SharePlanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SharePlanTableViewCell.self), for: indexPath)
                as? SharePlanTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.dayLabel.text = "第一天"
        cell.orderLbael.text = String(indexPath.row+1)
        cell.nameLabel.text = schedules[indexPath.row].name
        cell.addressLabel.text = schedules[indexPath.row].address
        cell.tripTimeLabel.text = "停留時間：\(schedules[indexPath.row].duration)小時"
        cell.trafficTimeLabel.text =  "交通時間：\(schedules[indexPath.row].trafficTime)小時"
        
        return cell
        
    }
    
}
