//
//  PlanPickerViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit

class PlanPickerViewController: UIViewController {
    
    private var departmentTimes = ["09:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30"]
    
    private var selectedDepartmentTimes: String = "09:00" {
        didSet {
            headerView.departmentPickerView.timeTextField.text = selectedDepartmentTimes
            self.scheduleTwo[0].startTime = selectedDepartmentTimes
            
        }
    }
    
    private var headerView: PlanCardHeaderView!
    var tripTitle: String = ""

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
    
    var tripSchedule: Trips? {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var zoomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerHeaderWithNib(identifier: String(describing: PlanCardHeaderView.self), bundle: nil)
        
        tableView.registerFooterWithNib(identifier: String(describing: PlanCardFooterView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: PlanCardTableViewCell.self), bundle: nil)
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(
            PlanPickerViewController.longPressGestureRecognized(_:)))
        tableView.addGestureRecognizer(longpress)
        
        fetchData()
    }
    // MARK: - Action
    func fetchData() {
        let tripProvider = TripProvider()
        
        tripProvider.fetchSchedule(tripId: 2,completion: { result in
            
            switch result {
                
            case .success(let tripSchedule):
                self.tripSchedule = tripSchedule
                print("tripSchedule", tripSchedule)
                
            case .failure:
                print("讀取資料失敗！")
            }
        })
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

extension PlanPickerViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
 
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: PlanCardHeaderView.identifier)
        as? PlanCardHeaderView else { return nil }

        headerView.titleLabel.text = tripTitle
        
        headerView.dateLabel.text = "\(departureDate)- \(backDate)"

        headerView.selectionView.delegate = self
        headerView.selectionView.dataSource = self

        headerView.departmentPickerView.picker.delegate = self

        headerView.departmentPickerView.picker.dataSource = self
        
        self.headerView = headerView
        headerView.departmentPickerView.timeTextField.text = selectedDepartmentTimes
        
        headerView.departmentPickerView.delegate = self
        
        return headerView
    }
    
    // MARK: - Section Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        50.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: PlanCardFooterView.identifier)
        as? PlanCardFooterView else { return nil }
        
        footerView.scheduleButton.addTarget(target, action: #selector(tapScheduleButton), for: .touchUpInside)
        
        return footerView
    }
    
    @objc func tapScheduleButton() {
    // MARK: - Delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "刪除") { _, index in
            tableView.isEditing = false
            
            self.scheduleTwo.remove(at: index.row)
        }
        return [deleteAction]
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
            cell.startTime = "09:00"

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

extension PlanPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return departmentTimes.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return "\(departmentTimes[row])"
        
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        self.selectedDepartmentTimes = departmentTimes[row]
                
    }
}

extension PlanPickerViewController: TimePickerViewDelegate {
    func donePickerViewAction() {
       
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
    func didSelectedButton(_ selectionView: SelectionView, at index: Int) {
        // tableView.backgroundColor = daySource[index].color
    }
    
    func shouldSelectedButton(_ selectionView: SelectionView, at index: Int) -> Bool {
            return true
    }
}
