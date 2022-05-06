//
//  PlanPickerViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit
import PusherSwift

protocol PlanPickerViewControllerDelegate: AnyObject {
    func reloadCollectionView(_ collectionView: UICollectionView)
}

class PlanPickerViewController: UIViewController {
    
    weak var reloadDelegate: PlanPickerViewControllerDelegate?
    
    var pusher: Pusher!
    
    private var friendListDataArray: [User] = []
    
    var headerCollectionView: UICollectionView!
    
    var scheduleClosure: ((_ schedule: [Schedule]) -> Void)?
    
    var tripClosure: ((_ schedule: Trip) -> Void)?

    var myTripId: Int?
    
    var tripId: Int? {
        didSet {
//            fetchData(days: 1)
        }
    }
    var trip: Trip? {
        didSet {
            tableView.reloadData()
            guard let trip = trip else { return  }
            tripClosure?(trip)
        }
    }
    
    var schedule: [Schedule] = [] {
        didSet {
            showLoadingView()
            if !self.schedule.isEmpty {
                self.schedule[0].startTime = selectedDepartmentTimes
            }
            rearrangeTime()
            tableView.reloadData()
            scheduleClosure?(schedule)
            
            // scrollToBottom()
        }
    }
    var currentDay = 1
    private var departmentTimes = ["09:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30"]
    private var headerView: PlanCardHeaderView!
    private var selectedDepartmentTimes: String = "09:00"

    private var isMoveDown: Bool = false
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    @IBOutlet weak var zoomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zoomButton.setBackgroundImage(UIImage.asset(.zoomIn), for: .normal)
        listenEvent()
        tableView.registerHeaderWithNib(identifier: String(describing: PlanCardHeaderView.self), bundle: nil)
        
        tableView.registerFooterWithNib(identifier: String(describing: PlanCardFooterView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: PlanCardTableViewCell.self), bundle: nil)
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(
            PlanPickerViewController.longPress(_:)))
        tableView.addGestureRecognizer(longpress)
        tableView.backgroundView = UIImageView(image: UIImage.asset(.planBackground)!)
        tableView.backgroundView?.contentMode = .scaleAspectFill
        tableView.backgroundColor = .clear
        
        self.tableView.contentInsetAdjustmentBehavior = .never

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData(days: 1)
    }
        
    // MARK: - GET Action
    private func fetchData(days: Int) {
        let tripProvider = TripProvider()
        
        guard let tripId = myTripId else { return  }

//        guard let tripId = tripId else { return  }
        
        tripProvider.fetchSchedule(tripId: tripId, days: days, completion: { [weak self] result in
            
            switch result {
                
            case .success(let tripSchedule):
                
                self?.trip = tripSchedule.data
                
                let schedule = tripSchedule.data.schedules?.first ?? []
                self?.selectedDepartmentTimes = schedule.first?.startTime ?? "9:00"
                self?.schedule = schedule
                
            case .failure:
                print("[PlanPicker] GET schedule Detai 讀取資料失敗！")
            }
        })
        
    }
    // MARK: - POST Action
    func postData(days: Int) {
        let tripProvider = TripProvider()
        guard let tripId = myTripId else { return }
        
        tripProvider.postTrip(tripId: tripId, schedules: schedule, day: days, completion: { result in
            
            switch result {
                
            case .success:
                self.showLoadingView()
                
            case .failure:
                print("POST TRIP DETAIL API讀取資料失敗！")
            }
        })
    }
    
    // MARK: - POST To Add Editor
    func postToAddEditor(editorId: Int) {
        let coEditProvider = CoEditProvider()
        guard let tripId = tripId else { return }
        
        coEditProvider.postToAddEditor(tripId: tripId, editorId: editorId, completion: { result in
            
            switch result {
                
            case .success(let coEditorResponse):
                print("coEditorResponse", coEditorResponse)
            case .failure:
                print("postToAddEditor失敗！")
            }
        })
    }
    
    // MARK: - Delete Editor
    func deleteEditor(editorId: Int) {
        let coEditProvider = CoEditProvider()
        guard let tripId = tripId else { return }
        
        coEditProvider.deleteCoEditor(tripId: tripId, editorId: editorId, completion: { result in
            
            switch result {
                
            case .success(let coEditorResponse):
                print("coEditorResponse", coEditorResponse)
            case .failure:
                print("postToDeleteEditor失敗！")
            }
        })
    }
    
    private func showLoadingView() {
        let loadingView = LoadingView()
        view.layoutLoadingView(loadingView, view)
    }
    
    @IBAction func tapZoomButton(_ sender: UIButton) {
        sender.isSelected = isMoveDown
        if isMoveDown {
            UIView.transition(with: self.view, duration: 0.2, options: [.curveLinear], animations: {
                self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
            }, completion: nil)
            
            zoomButton.setImage(UIImage.asset(.zoomIn), for: .selected)
            zoomButton.frame = CGRect(x: UIScreen.width - 170, y: 400, width: 50, height: 50)
            
        } else {
            UIView.transition(with: self.view, duration: 0.2, options: [.curveLinear], animations: {
                self.view.frame = CGRect(x: 0, y: 650, width: UIScreen.width, height: UIScreen.height)
            }, completion: nil)
            zoomButton.setBackgroundImage(UIImage.asset(.zoomOut), for: .normal)
            zoomButton.frame = CGRect(x: UIScreen.width - 170, y: 250, width: 50, height: 50)
            
        }
        isMoveDown = !isMoveDown
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
        
        guard let trip = trip else { return nil}
        headerView.layoutHeaderView(data: trip)
        
        headerView.titleLabel.text = trip.title
    
        headerView.selectionView.delegate = self
        headerView.selectionView.dataSource = self
        
        headerView.departmentPickerView.picker.delegate = self
        
        headerView.departmentPickerView.picker.dataSource = self
        
        self.headerView = headerView
        
        headerView.departmentPickerView.timeTextField.text = selectedDepartmentTimes
        
        headerView.departmentPickerView.delegate = self
        headerView.collectionView.registerCellWithNib(identifier: String(
            describing: FriendsCollectionViewCell.self), bundle: nil)
        
        headerView.collectionView.dataSource = self
        headerView.collectionView.delegate = self
        
        self.reloadDelegate = headerView
        
        self.headerCollectionView = headerView.collectionView
    
        headerView.inviteButton.addTarget(target, action: #selector(tapToInvite), for: .touchUpInside)
        
        return headerView
    }
    @objc func tapToInvite() {
        guard let friendListVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: StoryboardCategory.friendListVC) as? FriendListViewController else { return }
        
        guard let userId = KeyChainManager.shared.userId else { return }
        
        friendListVC.userId = Int(userId)
        
        friendListVC.isEditMode = true
        
        friendListVC.delegate = self

        friendListVC.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            if let sheet = friendListVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
        } else {
            // Fallback on earlier versions
        }
        self.present(friendListVC, animated: true)
//        shareLink()
    }
    
    // MARK: - Section Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        70.0
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
            self?.postData(days: self!.currentDay)
        }
        let navSearchVC = UINavigationController(rootViewController: searchVC)
        self.present(navSearchVC, animated: true)
        
    }
    // MARK: - Delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "刪除") { _, index in
            tableView.isEditing = false
            self.schedule.remove(at: index.row)
            self.postData(days: self.currentDay)
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
        
        tableView.separatorColor = .clear
        tripCell.layouCell(data: schedule[indexPath.row], index: indexPath.row)
        
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
        headerView.departmentPickerView.timeTextField.text = selectedDepartmentTimes
        if !self.schedule.isEmpty {
            self.schedule[0].startTime = selectedDepartmentTimes
        }
    }
    
}

extension PlanPickerViewController: SegmentControlViewDataSource {
    
    func configureNumberOfButton(_ selectionView: SegmentControlView) -> Int {
        trip?.days ?? 1
    }
    
}

@objc extension PlanPickerViewController: SegmentControlViewDelegate {
    func didSelectedButton(_ selectionView: SegmentControlView, at index: Int) {
        postData(days: currentDay)
        currentDay = index
        fetchData(days: index)
        
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
// MARK: - CollectionView
extension PlanPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return friendListDataArray.count
        return trip?.editors.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: FriendsCollectionViewCell.self),
            for: indexPath) as? FriendsCollectionViewCell else { return UICollectionViewCell() }

//        cell.layoutCell(data: friendListDataArray, index: indexPath.row)
        guard let editors = trip?.editors else { return UICollectionViewCell() }
          cell.layoutCell(data: editors, index: indexPath.row)

//        let last = max(numberOfFriends, 0) - 1
//        if indexPath.item == last {
//            cell.contentView.backgroundColor = .themeApricotDeep
//            collectionView.reloadData()
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let last = max(numberOfFriends, 0) - 1
//        if indexPath.item == last {
//            // shareLink() 行為很奇怪要按很多下
//        }
        
    }
    
    func shareLink() {
        let shareURl = URL(string: "https://game.dev.newideas.com.tw/")!
        let shareText = "Sally邀請你共同編輯旅遊行程"
        let items: [Any] = [shareURl, shareText]
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}

extension PlanPickerViewController: FriendListViewControllerDelegate {
    func removeCoEditFriendsData(_ friendListData: User, _ index: Int) {
        deleteEditor(editorId: friendListData.id)
        self.trip?.editors.removeAll(where: { $0 == friendListData })

//        friendListDataArray.removeAll(where: { $0 == friendListData })
        self.reloadDelegate?.reloadCollectionView(headerCollectionView)

    }
    
    func passingCoEditFriendsData(_ friendListData: User) {
        postToAddEditor(editorId: friendListData.id)
        
        self.trip?.editors.append(friendListData)
//        self.friendListDataArray.append(friendListData)
        self.reloadDelegate?.reloadCollectionView(headerCollectionView)
    }
    
}

extension PlanPickerViewController: UICollectionViewDelegateFlowLayout {
    var itemSize: CGSize {
        get {
            return CGSize(width: 40, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
}

extension PlanPickerViewController: PusherDelegate {
    // MARK: - PusherSwift
    
    func listenEvent() {

            let options = PusherClientOptions(
                host: .cluster("ap3")
            )
    
            pusher = Pusher(
                key: KeyConstants.pusherKey,
                options: options
            )
    
            pusher.delegate = self
    
            // subscribe to channel
            let channel = pusher.subscribe("trip")
    
            // bind a callback to handle an event
            let _ = channel.bind(eventName: "server.updated", eventCallback: { (event: PusherEvent) in
                if let data = event.data {
                    do {
    
                        let tripSchedule = try JSONDecoder().decode(
                            Schedules.self,
                            from: data.data(using: .utf8)!
                        )
//                        print("Decode Data:", tripSchedule)
                        if tripSchedule.tripId != self.tripId { return }
                        if tripSchedule.schedules.first?.day != self.currentDay { return }
                        self.schedule = tripSchedule.schedules
                        self.rearrangeTime()
                        self.tableView.reloadData()
                    } catch {
                        print(error)
                    }
    
                }
            })
    
            pusher.connect()
    
        }
//    func debugLog(message: String) {
//        print("Pusher debug messages:", message)
//    }
    
}
