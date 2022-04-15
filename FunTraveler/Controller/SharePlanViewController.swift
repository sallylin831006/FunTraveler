//
//  PublishViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/15.
//

import UIKit

class SharePlanViewController: UIViewController {
    
    var schedules: [Schedule] = []
    
    var isSimpleMode: Bool = true {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellWithNib(identifier: String(describing: ShareExperienceTableViewCell.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: SharePlanTableViewCell.self), bundle: nil)
        
        addSwitchButton()
    }
    
    func addSwitchButton() {
        let switchButton = UIButton()
        switchButton.frame = CGRect(x: 300, y: 100, width: 30, height: 30)
        switchButton.backgroundColor = .systemYellow
        self.view.addSubview(switchButton)
        
        switchButton.addTarget(target, action: #selector(tapSwitchButton), for: .touchUpInside)
        
    }
    
    @objc func tapSwitchButton() {
        isSimpleMode = !isSimpleMode
    }
    
}

extension SharePlanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSimpleMode {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SharePlanTableViewCell.self), for: indexPath)
                    as? SharePlanTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
  
            cell.orderLbael.text = String(indexPath.row+1)
            cell.nameLabel.text = schedules[indexPath.row].name
            cell.addressLabel.text = schedules[indexPath.row].address
            cell.tripTimeLabel.text = "停留時間：\(schedules[indexPath.row].duration)小時"
            
            return cell
        } else {
            guard let experienceCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ShareExperienceTableViewCell.self), for: indexPath)
                    as? ShareExperienceTableViewCell else { return UITableViewCell() }
            experienceCell.selectionStyle = .none

            experienceCell.orderLbael.text = String(indexPath.row+1)
            experienceCell.nameLabel.text = schedules[indexPath.row].name
            experienceCell.addressLabel.text = schedules[indexPath.row].address
            experienceCell.tripTimeLabel.text = "停留時間：\(schedules[indexPath.row].duration)小時"
            experienceCell.imageView?.backgroundColor = .red
            
            return experienceCell
        }
       
    }
    
}
