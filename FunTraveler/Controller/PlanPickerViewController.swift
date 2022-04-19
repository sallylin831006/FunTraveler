//
//  PlanPickerViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit

class PlanPickerViewController: UIViewController {

    var scheduleClosure: ((_ schedule: [Schedule]) -> Void)?
    
    var tripId: Int? {
        didSet {
            fetchData(days: 1)
        }
    }
    var trip: Trip? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var schedule: [Schedule] = [] {
        didSet {
            rearrangeTime()
            tableView.reloadData()
            scheduleClosure?(schedule)
            // scrollToBottom()
        }
    }
    
    private var departmentTimes = ["09:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30"]
    private var headerView: PlanCardHeaderView!
    private var selectedDepartmentTimes: String = "09:00" {
        didSet {
            headerView.departmentPickerView.timeTextField.text = selectedDepartmentTimes
            self.schedule[0].startTime = selectedDepartmentTimes
                        
        }
    }

    private var daySource: [DayModel] = []
    
//    DayModel(color: .red, title: "第一天"),
//    DayModel(color: .yellow, title: "第二天"),
//    DayModel(color: .green, title: "第三天"),
//    DayModel(color: .green, title: "第四天")
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self

            tableView.delegate = self
            
        }
    }
    
    private var isMoveDown: Bool = false
    @IBOutlet weak var zoomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerHeaderWithNib(identifier: String(describing: PlanCardHeaderView.self), bundle: nil)
        
        tableView.registerFooterWithNib(identifier: String(describing: PlanCardFooterView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: PlanCardTableViewCell.self), bundle: nil)
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(
            PlanPickerViewController.longPress(_:)))
        tableView.addGestureRecognizer(longpress)

    }
    
// MARK: - GET Action
    private func fetchData(days: Int) {
        let tripProvider = TripProvider()

        guard let tripId = tripId else { return  }

        tripProvider.fetchSchedule(tripId: tripId, days: days, completion: { [weak self] result in
            
            switch result {
                
            case .success(let tripSchedule):

                self?.trip = tripSchedule.data
                
                guard let schedules = tripSchedule.data.schedules else { return }

                guard let schedule = schedules.first else { return }
                
                self?.schedule = schedule
                print("[PlanPicker] GET schedule Detail:", tripSchedule)
                
            case .failure:
                print("[PlanPicker] GET schedule Detai 讀取資料失敗！")
            }
        })
        
    }
    // MARK: - POST Action
    private func postData(days: Int) {
        let tripProvider = TripProvider()
        guard let tripId = tripId else { return }
        
        tripProvider.postTrip(tripId: tripId, schedules: schedule, day: days, completion: { result in
            
            switch result {
                
            case .success:
                print("POST TRIP DETAIL API成功！")
                
            case .failure:
                print("POST TRIP DETAIL API讀取資料失敗！")
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
            zoomButton.setBackgroundImage(UIImage.asset(.zoomOut), for: .normal)
            zoomButton.frame = CGRect(x: UIScreen.width - 170, y: 250, width: 50, height: 50)
            
            isMoveDown = true
        }
    }
    
}

extension PlanPickerViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 250.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: PlanCardHeaderView.identifier)
                as? PlanCardHeaderView else { return nil }
        
        guard let trip = trip,
        let tripStartDate = trip.startDate,
        let tripEndtDate = trip.endDate
        else { return nil}

        headerView.titleLabel.text = trip.title

        headerView.dateLabel.text = "\(tripStartDate) - \(tripEndtDate)"

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
        footerView.scheduleButton.setTitle("+新增景點", for: .normal)
        
        footerView.scheduleButton.addTarget(target, action: #selector(tapScheduleButton), for: .touchUpInside)
        
        return footerView
    }
    
    @objc func tapScheduleButton() {

        guard let searchVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.searchVC) as? SearchViewController else { return }
        searchVC.scheduleArray = schedule
        
        if schedule.isEmpty {
            searchVC.day = 1
        } else {
            searchVC.day = schedule[0].day
        }
        
        searchVC.scheduleClosure = { [weak self] newSchedule in
            self?.schedule = newSchedule
        }
        let navSearchVC = UINavigationController(rootViewController: searchVC)
        self.present(navSearchVC, animated: true)
        
    }
    // MARK: - Delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "刪除") { _, index in
            tableView.isEditing = false

            self.schedule.remove(at: index.row)
        }
        return [deleteAction]
    }
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tripCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PlanCardTableViewCell.self), for: indexPath)
                as? PlanCardTableViewCell else { return UITableViewCell() }
        tripCell.selectionStyle = .none

        tripCell.nameLabel.text = schedule[indexPath.row].name
        tripCell.addressLabel.text = schedule[indexPath.row].address
        tripCell.startTime = schedule[indexPath.row].startTime

        tripCell.durationTime = schedule[indexPath.row].duration

        tripCell.trafficTime = schedule[indexPath.row].trafficTime

        tripCell.orderLabel.text = String(indexPath.row + 1)

        tripCell.index = indexPath.row

        tripCell.delegate = self

        return tripCell
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async {
            let number = self.schedule.count

            let indexPath = IndexPath(row: number-1, section: 0)
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

extension PlanPickerViewController: SegmentControlViewDataSource {
    
    func configureNumberOfButton(_ selectionView: SegmentControlView) -> Int {
        
        //return daySource.count
        trip?.days ?? 1
    }
    
    func configureDetailOfButton(_ selectionView: SegmentControlView) -> [DayModel] {
        return daySource
        
    }
    
    func colorOfindicator() -> UIColor { .black }
    
    func colorOfText() -> UIColor { .black }
    
}

@objc extension PlanPickerViewController: SegmentControlViewDelegate {
    func didSelectedButton(_ selectionView: SegmentControlView, at index: Int) {
        fetchData(days: index)
        postData(days: index)
    }
    
    func shouldSelectedButton(_ selectionView: SegmentControlView, at index: Int) -> Bool {
        return true
    }
}

extension PlanPickerViewController: PlanCardTableViewCellDelegate {
    func updateTime(startTime: String, duration: Double, trafficTime: Double, index: Int) {
        
        self.schedule[index].startTime = startTime
        self.schedule[index].duration = duration
        self.schedule[index].trafficTime = trafficTime
        
    }
    
    func rearrangeTime() {
        var previousEndTime = ""
        for (index, schedule) in self.schedule.enumerated() {
            do {
                let totalDuration = schedule.duration + schedule.trafficTime
                let date = try TimeManager.getDateFromString(startTime: schedule.startTime, duration: totalDuration)
                
                let endTime = "\(date.endHours):\(String(format: "%02d", date.endMinutes))"
                
                if schedule.startTime == previousEndTime || previousEndTime == "" {
                    previousEndTime = endTime
                    continue
                }
                
                self.schedule[index].startTime = previousEndTime
                
                let newDate = try TimeManager.getDateFromString(startTime: previousEndTime, duration: totalDuration)
                
                let newEndTime = "\(newDate.endHours):\(String(format: "%02d", newDate.endMinutes))"
                
                previousEndTime = newEndTime
                
            } catch let wrongError {
                print("Error message: \(wrongError),Please add correct time!")
            }
        }
    }
    
}
