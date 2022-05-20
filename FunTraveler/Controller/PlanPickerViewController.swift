//
//  PlanPickerViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit

protocol PlanPickerViewControllerDelegate: AnyObject {
    func reloadCollectionView(_ collectionView: UICollectionView)
}

class PlanPickerViewController: UIViewController {
    // MARK: - Property
    weak var reloadDelegate: PlanPickerViewControllerDelegate?
        
    var currentDay: Int = 1
    
    var currentdayClosure: ((_ currentday: Int) -> Void)? //naming
    
    var tripClosure: ((_ schedule: Trip) -> Void)?
    
    var scheduleClosure: ((_ schedule: [Schedule]) -> Void)?
    
    var tripId: Int? //
    
    var trip: Trip? // didset
    
    var schedule: [Schedule] = [] { //
        didSet {
            schedule = rearrangeTimeManager.rearrangeSchedulesTime(schedule)
        }
    }
    
    private var selectedDepartmentTime: String = "09:00"
    private var isMoveDown: Bool = false
    
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    let rearrangeTimeManager = RearrangeTimeManager()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let pusherManager = PusherManager()
        pusherManager.delegate = self
        pusherManager.listenEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData(days: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTableViewUI()
        setupZoomButton()
    }
}

extension PlanPickerViewController {
    // MARK: - GET Action
    private func fetchData(days: Int) {
        let tripProvider = TripProvider()
        
        guard let tripId = tripId else { return }
        
        tripProvider.fetchSchedule(tripId: tripId, days: days, completion: { [weak self] result in
            
            switch result {
                
            case .success(let tripSchedule):
                
                self?.trip = tripSchedule.data
                self?.tripClosure?(tripSchedule.data)
                
                let schedule = tripSchedule.data.schedules?.first ?? []
                self?.schedule = schedule
                self?.scheduleClosure?(schedule)
                
                self?.selectedDepartmentTime = schedule.first?.startTime ?? "9:00"
                
                self?.tableView.reloadData()
                
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
            }
        })
    }
    // MARK: - POST Action
    func postData(days: Int, isFinished: Bool) {
        let tripProvider = TripProvider()
        guard let tripId = tripId else { return }
        if !self.schedule.isEmpty {
            self.schedule[0].startTime = self.selectedDepartmentTime
        }
        tripProvider.postTrip(tripId: tripId, schedules: schedule, day: days, isFinished: isFinished, completion: { [weak self] result in
            switch result {
            case .success:
                self?.tableView.reloadData()
            case .failure:
                ProgressHUD.showFailure(text: "行程更新失敗")
            }
        })
    }
    
    // MARK: - POST Action
    private func postToAddEditor(editor: User) {
        let coEditProvider = CoEditProvider()
        guard let tripId = tripId else { return }
        
        coEditProvider.postToAddEditor(tripId: tripId, editorId: editor.id, completion: { result in
            switch result {
            case .success(_):
                self.trip?.editors.append(editor)
                self.tableView.reloadData()
                ProgressHUD.showSuccess()
            case .failure:
                ProgressHUD.showFailure()
            }
        })
    }
    
    // MARK: - Delete Action
    private func deleteEditor(editor: User) {
        let coEditProvider = CoEditProvider()
        guard let tripId = tripId else { return }
        coEditProvider.deleteCoEditor(tripId: tripId, editorId: editor.id, completion: { result in
            switch result {
            case .success(_):
                self.trip?.editors.removeAll(where: { $0 == editor })
                self.tableView.reloadData()
                ProgressHUD.showSuccess()
            case .failure:
                ProgressHUD.showFailure()
            }
        })
    }
}

// MARK: - TableView DataSourse & Delegate

extension PlanPickerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: PlanCardHeaderView.identifier)
                as? PlanCardHeaderView else { return nil }
        
        guard let trip = trip else { return nil }
        headerView.layoutHeaderView(data: trip)
        headerView.delegate = self
        headerView.reloadCollectionView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.schedule.remove(at: indexPath.row)
            self.postData(days: self.currentDay, isFinished: false)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PlanCardTableViewCell.self), for: indexPath)
                as? PlanCardTableViewCell else { return UITableViewCell() }
        
        let rearrangeTrafficTime = rearrangeTimeManager.calculateTrafficTime(indexPath.row, self.schedule)
        
        cell.trafficTime = rearrangeTrafficTime
        
        cell.layouCell(data: schedule[indexPath.row], index: indexPath.row)
        
        cell.delegate = self
        
        return cell
    }
}

// MARK: - HeaderView Delegate
extension PlanPickerViewController: PlanCardHeaderViewDelegate {
    
    internal func passingSelectedDepartmentTime(_ headerView: PlanCardHeaderView, _ selectedDepartmentTime: String) {
        if !self.schedule.isEmpty {
            self.schedule[0].startTime = selectedDepartmentTime
            self.selectedDepartmentTime = selectedDepartmentTime
        }
        postData(days: currentDay, isFinished: false)
        fetchData(days: currentDay)
    }
    
    internal func tapToInviteFriends(_ button: UIButton) {
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
        } else {
            
        }
        self.present(friendListVC, animated: true)
    }
    
    internal func switchDayButton(index: Int) {
        postData(days: currentDay, isFinished: false) // cache?
        currentDay = index
        currentdayClosure?(index)
        fetchData(days: index)
    }
}

// MARK: - PlanCardCellDelegate
extension PlanPickerViewController: PlanCardTableViewCellDelegate {
    internal func updateTime(startTime: String, duration: Double, trafficTime: Double, index: Int) {
        
        self.schedule[index].startTime = startTime
        self.schedule[index].duration = duration
        self.schedule[index].trafficTime = trafficTime
        
    }
}

// MARK: - FriendListDelegate
extension PlanPickerViewController: FriendListViewControllerDelegate {
    internal func removeCoEditFriendsData(_ friendListData: User, _ index: Int) {
        deleteEditor(editor: friendListData)
    }
    
    internal func passingCoEditFriendsData(_ friendListData: User) {
        postToAddEditor(editor: friendListData)
    }
    
}

// MARK: - Friends Co-Editing Pusher

extension PlanPickerViewController: PusherManagerDelegate {
    
    func updaateSchedules(tripSchedule: Schedules) {
        if tripSchedule.tripId != self.tripId { return }
        if tripSchedule.schedules.first == nil {
            self.schedule = []
            self.tableView.reloadData()
        }
        if tripSchedule.schedules.first?.day != self.currentDay { return }
        self.schedule = tripSchedule.schedules
        schedule = rearrangeTimeManager.rearrangeSchedulesTime(schedule)
        self.tableView.reloadData()
    }
}

extension PlanPickerViewController {
    private func setupTableViewUI() {
        self.bottomHeightConstraint.constant = UIScreen.height/14
        tableView.backgroundView = UIImageView(image: UIImage.asset(.planBackground)!)
        tableView.backgroundView?.contentMode = .scaleAspectFill
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.registerHeaderWithNib(identifier: String(describing: PlanCardHeaderView.self), bundle: nil)
        tableView.registerFooterWithNib(identifier: String(describing: PlanCardFooterView.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: PlanCardTableViewCell.self), bundle: nil)
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(
            PlanPickerViewController.longPress(_:)))
        tableView.addGestureRecognizer(longpress)
    }
    
    private func setupZoomButton() {
        let zoomButton = UIButton()
//        zoomButton.setImage(UIImage.asset(.collectNormal), for: .normal)
//        zoomButton.setBackgroundImage(UIImage(systemName: "arrow.down.square.fill"), for: .normal)
        self.view.addSubview(zoomButton)
        zoomButton.addTarget(self, action: #selector(tapZoomBtn(_:)), for: .touchUpInside)
        
        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        zoomButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        zoomButton.bottomAnchor.constraint(
            equalTo: tableView.topAnchor, constant: -10).isActive = true
        zoomButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        zoomButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
//        zoomButton.tintColor = UIColor.themeApricotDeep
        zoomButton.backgroundColor = .themeApricotDeep

        
//        let width: CGFloat = 50
//        zoomButton.frame = CGRect(x: UIScreen.width - 70, y: 100, width: width, height: width) //
//        zoomButton.setBackgroundImage(UIImage.asset(.zoomIn), for: .normal)
        
        
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
                self.view.frame = CGRect(x: 0, y: 660, width: UIScreen.width, height: UIScreen.height) //
            }, completion: nil)
            sender.setBackgroundImage(UIImage.asset(.zoomOut), for: .normal)
        }
        isMoveDown = !isMoveDown
    }
}


