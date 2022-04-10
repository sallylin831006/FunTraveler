//
//  PlanPickerViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit

class PlanPickerViewController: UIViewController {
    var planCard = ["1", "2", "3", "4", "5"] {
        didSet {
            tableView.reloadData()
            scrollToBottom()
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
        tableView.registerCellWithNib(identifier: String(describing: PlanCardTableViewCell.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: TrafficTimeTableViewCell.self), bundle: nil)

    }
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        planCard.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PlanCardTableViewCell.self), for: indexPath)
                    as? PlanCardTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.nameLabel.text = "景福宮"
            cell.addressLabel.text = "保安三街8-1號"
            cell.layoutCell(startTime: "09:30") // ADJUST 00:00

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TrafficTimeTableViewCell.self), for: indexPath)
                    as? TrafficTimeTableViewCell else { return UITableViewCell() }
            
            cell.trafficTimeLabel.text = "開車時間"

            return cell
        }
        
    }

    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.planCard.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

}
