//
//  PlanPickerViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit
import PusherSwift
import CoreLocation

protocol PlanPickerViewControllerDelegate: AnyObject {
    func reloadCollectionView(_ collectionView: UICollectionView)
}

class PlanPickerViewController: UIViewController {
    
    weak var reloadDelegate: PlanPickerViewControllerDelegate?
    
    var pusher: Pusher!
    
    private var headerCollectionView: UICollectionView!
    
    var currentdayClosure: ((_ currentday: Int) -> Void)?
    
    var currentDay: Int = 1
    
    var scheduleClosure: ((_ schedule: [Schedule]) -> Void)?
    
    var tripClosure: ((_ schedule: Trip) -> Void)?
    
    var myTripId: Int?
    
    var trip: Trip? {
        didSet {
            guard let trip = trip else { return }
            tripClosure?(trip)
        }
    }

    var schedule: [Schedule] = [] {
        didSet {
            rearrangeTime()
            scheduleClosure?(schedule)
        }
    }
    
    private var fixedDepartmentTime: String?
    private var headerView: PlanCardHeaderView!
    private var isMoveDown: Bool = false
    
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData(days: 1)
        setupZoomButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTableViewUI()
    }
}

extension PlanPickerViewController {
    // MARK: - GET Action
    private func fetchData(days: Int) {
        let tripProvider = TripProvider()
        
        guard let tripId = myTripId else { return }
        
        tripProvider.fetchSchedule(tripId: tripId, days: days, completion: { [weak self] result in
            
            switch result {
                
            case .success(let tripSchedule):
                self?.trip = tripSchedule.data
                
                let schedule = tripSchedule.data.schedules?.first ?? []
                self?.schedule = schedule
                
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
            }
        })
    }
    // MARK: - POST Action
    func postData(days: Int, isFinished: Bool) {
        let tripProvider = TripProvider()
        guard let tripId = myTripId else { return }
        tripProvider.postTrip(tripId: tripId, schedules: schedule, day: days, isFinished: isFinished, completion: { [weak self] result in
            switch result {
            case .success:
                if !self!.schedule.isEmpty {
                    self?.schedule[0].startTime = self?.fixedDepartmentTime ?? "9:00"
                }
                self?.tableView.reloadData()
            case .failure:
                ProgressHUD.showFailure(text: "行程儲存失敗")
            }
        })
    }
    
    // MARK: - POST To Add Editor
    func postToAddEditor(editorId: Int) {
        let coEditProvider = CoEditProvider()
        guard let tripId = myTripId else { return }
        
        coEditProvider.postToAddEditor(tripId: tripId, editorId: editorId, completion: { result in
            switch result {
            case .success(_):
                ProgressHUD.showSuccess(text: "成功加入")
            case .failure:
                ProgressHUD.showFailure(text: "新增失敗")
            }
        })
    }
    
    // MARK: - Delete Editor
    func deleteEditor(editorId: Int) {
        let coEditProvider = CoEditProvider()
        guard let tripId = myTripId else { return }
        coEditProvider.deleteCoEditor(tripId: tripId, editorId: editorId, completion: { result in
            switch result {
            case .success(_):
                ProgressHUD.showSuccess(text: "成功移除")
            case .failure:
                ProgressHUD.showFailure(text: "移除失敗")
            }
        })
    }
}
// MARK: - TableView

extension PlanPickerViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: PlanCardHeaderView.identifier)
                as? PlanCardHeaderView else { return nil }
        headerView.collectionView.registerCellWithNib(identifier: String(
            describing: FriendsCollectionViewCell.self), bundle: nil)
        
        guard let trip = trip else { return nil }
        headerView.layoutHeaderView(data: trip)
        headerView.delegate = self
        headerView.collectionView.dataSource = self
        headerView.collectionView.delegate = self
        
        self.reloadDelegate = headerView
        self.headerView = headerView
        self.headerCollectionView = headerView.collectionView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.schedule.remove(at: indexPath.row)
            self.postData(days: self.currentDay, isFinished: false)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip?.schedules?.count ?? 0
//        schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PlanCardTableViewCell.self), for: indexPath)
                as? PlanCardTableViewCell else { return UITableViewCell() }
        
        tableView.separatorColor = .clear
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(
            PlanPickerViewController.longPress(_:)))
        tableView.addGestureRecognizer(longpress)
        
        let rearrangeTrafficTime = (calculateTrafficTime(index: indexPath.row)/1000).ceiling(toInteger: 1)
        cell.trafficTime = rearrangeTrafficTime
        cell.layouCell(data: schedule[indexPath.row], index: indexPath.row)
        
        cell.index = indexPath.row
        cell.delegate = self
        
        return cell
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
        for (index, plan) in self.schedule.enumerated() {
            do {
                let distance = (calculateTrafficTime(index: index)/1000).ceiling(toInteger: 1)
                let totalDuration = plan.duration + distance/60
                
                let date = try TimeManager.getDateFromString(startTime: plan.startTime, duration: totalDuration)
                
                let endTime = "\(date.endHours):\(String(format: "%02d", date.endMinutes))"
                
                if plan.startTime == previousEndTime || previousEndTime == "" {
                    previousEndTime = endTime
                    continue
                }
                
                self.schedule[index].startTime = previousEndTime
                
                let newDate = try TimeManager.getDateFromString(startTime: previousEndTime, duration: totalDuration)
                
                let newEndTime = "\(newDate.endHours):\(String(format: "%02d", newDate.endMinutes))"
                
                previousEndTime = newEndTime
                
            } catch let wrongError {
                print("Error message: \(wrongError), Please add correct time!")
            }
        }
        tableView.reloadData()
    }
    
    func calculateTrafficTime(index: Int) -> Double {
        let lastIndex = schedule.count - 1
        if index == lastIndex {
            return 0
        }
        let coordinate₀ = CLLocation(
            latitude: schedule[index].position.lat,
            longitude: schedule[index].position.long
        )
        
        let coordinate₁ = CLLocation(
            latitude: schedule[index+1].position.lat,
            longitude: schedule[index+1].position.long
        )
        return coordinate₀.distance(from: coordinate₁)
    }
    
}
extension PlanPickerViewController: PlanCardHeaderViewDelegate {
    func passingSelectedDepartmentTime(_ selectedDepartmentTime: String) {
        headerView.departmentPickerView.timeTextField.text = selectedDepartmentTime
        if !self.schedule.isEmpty {
            self.schedule[0].startTime = selectedDepartmentTime
            self.fixedDepartmentTime = selectedDepartmentTime
        }
    }
    
    func tapToInviteFriends(_ button: UIButton) {
        guard let friendListVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: StoryboardCategory.friendListVC) as? FriendListViewController else { return }
        
        guard let userId = KeyChainManager.shared.userId else { return }
        
        friendListVC.userId = Int(userId)
        
        friendListVC.isEditMode = true
        
        friendListVC.delegate = self
        
        friendListVC.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            let sheet = friendListVC.sheetPresentationController
            sheet?.detents = [.medium(), .large()]
        }
        self.present(friendListVC, animated: true)
    }
    
    func switchDayButton(index: Int) {
        postData(days: currentDay, isFinished: false)
        currentDay = index
        currentdayClosure?(index)
        fetchData(days: index)
    }
}


// MARK: - Friends Co-Editing CollectionView
extension PlanPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trip?.editors.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: FriendsCollectionViewCell.self),
            for: indexPath) as? FriendsCollectionViewCell else { return UICollectionViewCell() }
        
        guard let editors = trip?.editors else { return UICollectionViewCell() }
        cell.layoutCell(data: editors, index: indexPath.row)
        
        return cell
    }
}

extension PlanPickerViewController: FriendListViewControllerDelegate {
    func removeCoEditFriendsData(_ friendListData: User, _ index: Int) {
        deleteEditor(editorId: friendListData.id)
        self.trip?.editors.removeAll(where: { $0 == friendListData })
        self.reloadDelegate?.reloadCollectionView(headerCollectionView)
        
    }
    
    func passingCoEditFriendsData(_ friendListData: User) {
        postToAddEditor(editorId: friendListData.id)
        self.trip?.editors.append(friendListData)
        self.reloadDelegate?.reloadCollectionView(headerCollectionView)
    }
    
}

extension PlanPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(5)
    }
}
// MARK: - Friends Co-Editing Pusher
extension PlanPickerViewController: PusherDelegate {
    func listenEvent() {
        let options = PusherClientOptions(host: .cluster("ap3"))
        
        pusher = Pusher(key: KeyConstants.pusherKey, options: options)
        
        pusher.delegate = self
        
        let channel = pusher.subscribe("trip")
        
        let _ = channel.bind(eventName: "server.updated", eventCallback: { (event: PusherEvent) in
            if let data = event.data {
                do {
                    
                    let tripSchedule = try JSONDecoder().decode(
                        Schedules.self,
                        from: data.data(using: .utf8)!
                    )
                    
                    if tripSchedule.tripId != self.myTripId { return }
                    if tripSchedule.schedules.first == nil {
                        self.schedule = []
                        self.tableView.reloadData()
                    }
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
    
}

extension PlanPickerViewController {
    func setupTableViewUI() {
        self.bottomHeightConstraint.constant = UIScreen.height/14
        tableView.backgroundView = UIImageView(image: UIImage.asset(.planBackground)!)
        tableView.backgroundView?.contentMode = .scaleAspectFill
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.registerHeaderWithNib(identifier: String(describing: PlanCardHeaderView.self), bundle: nil)
        tableView.registerFooterWithNib(identifier: String(describing: PlanCardFooterView.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: PlanCardTableViewCell.self), bundle: nil)
    }
    
    func setupZoomButton() {
        let zoomButton = UIButton()
        self.view.addSubview(zoomButton)
        let width: CGFloat = 50
        zoomButton.frame = CGRect(x: UIScreen.width - 70, y: 100, width: width, height: width)
        zoomButton.setBackgroundImage(UIImage.asset(.zoomIn), for: .normal)
        zoomButton.addTarget(self, action: #selector(tapZoomBtn(_:)), for: .touchUpInside)
        
    }
    @objc func tapZoomBtn(_ sender: UIButton) {
        sender.isSelected = isMoveDown
        if isMoveDown {
            UIView.transition(with: self.view, duration: 0.2, options: [.curveLinear], animations: {
                self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
            }, completion: nil)
            
            sender.setImage(UIImage.asset(.zoomIn), for: .selected)
        } else {
            UIView.transition(with: self.view, duration: 0.2, options: [.curveLinear], animations: {
                self.view.frame = CGRect(x: 0, y: 660, width: UIScreen.width, height: UIScreen.height)
            }, completion: nil)
            sender.setBackgroundImage(UIImage.asset(.zoomOut), for: .normal)
        }
        isMoveDown = !isMoveDown
    }
}


