//
//  PlanPickerViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit

class PlanPickerViewController: UIViewController {
    var isMoveDown: Bool = false

    let daySource = [
        DayModel(color: .red, title: "第一天"),
        DayModel(color: .yellow, title: "第二天"),
        DayModel(color: .green, title: "第三天"),
        DayModel(color: .green, title: "第四天")
    ]

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
    
    @IBOutlet weak var zoomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellWithNib(identifier: String(describing: PlanCardTableViewCell.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: TrafficTimeTableViewCell.self), bundle: nil)

    }
    @IBAction func tapZoomButton(_ sender: UIButton) {
        if isMoveDown == true {
            UIView.transition(with: self.view, duration: 0.2, options: [.curveLinear], animations: {
                self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
            }, completion: nil)
            
            zoomButton.setImage(UIImage.asset(.zoomIn), for: .selected)
            zoomButton.frame = CGRect(x: UIScreen.width - 170, y: 400, width: 50, height: 50)
            isMoveDown = false
        } else {
            UIView.transition(with: self.view, duration: 0.2, options: [.curveLinear], animations: {
                self.view.frame = CGRect(x: 0, y: 550, width: UIScreen.width, height: UIScreen.height)
            }, completion: nil)
            zoomButton.setBackgroundImage(UIImage.asset(.zoomIn), for: .selected)
            zoomButton.frame = CGRect(x: UIScreen.width - 170, y: 250, width: 50, height: 50)

            isMoveDown = true
        }
    }
    
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

extension PlanPickerViewController: SelectionViewDataSource {
    
    func configureNumberOfButton(_ selectionView: SelectionView) -> Int {
        
        return daySource.count
    }
    
    func configureDetailOfButton(_ selectionView: SelectionView) -> [DayModel] {
        return daySource

    }
    
    func colorOfindicator() -> UIColor { .black }
    
    func colorOfText() -> UIColor { .black }
    
}

@objc extension PlanPickerViewController: SelectionViewDelegate {
    @objc func didSelectedButton(_ selectionView: SelectionView, at index: Int) {
        // tableView.backgroundColor = daySource[index].color
    }
    
    @objc func shouldSelectedButton(_ selectionView: SelectionView, at index: Int) -> Bool {
            return true
    }
}
