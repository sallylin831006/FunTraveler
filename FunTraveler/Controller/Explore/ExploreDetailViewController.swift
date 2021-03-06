//
//  ExploreDetailViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/17.
//

import Foundation
import Kingfisher

import UIKit
class ExploreDetailViewController: UIViewController {
    
    var tripId: Int?
    
    var days: Int?
    
    var trip: Trip?
    
    var schedule: [Schedule] = [] {
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
        setupTableView()
        fetchData(days: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setupNaviagtionBar()
        setupBackButton()
    }
    
}

extension ExploreDetailViewController {
    // MARK: - GET Action
    private func fetchData(days: Int) {
        let tripProvider = TripProvider()
        ProgressHUD.show()
        guard let tripId = tripId else { return }
        
        tripProvider.fetchSchedule(tripId: tripId, days: days, completion: { [weak self] result in
            ProgressHUD.dismiss()
            switch result {
                
            case .success(let tripSchedule):
                
                guard let schedules = tripSchedule.data.schedules else { return }
                self?.trip = tripSchedule.data
                self?.schedule = schedules.first ?? []
                
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
            }
        })
        
    }
    
    // MARK: - POST TO ADD NEW COLLECTED
    private func postData(isCollected: Bool, tripId: Int) {
        let collectedProvider = CollectedProvider()
        
        collectedProvider.addCollected(isCollected: isCollected,
                                       tripId: tripId, completion: { result in
            
            switch result {
                
            case .success: break
            case .failure:
                ProgressHUD.showFailure()
            }
        })
        
    }
    
    // MARK: - POST TO Like
    private func postLiked() {
        let reactionProvider = ReactionProvider()
        guard let tripId = trip?.id else { return }
        reactionProvider.postToLiked(tripId: tripId, completion: { result in
            
            switch result {
                
            case .success: break
                
            case .failure:
                ProgressHUD.showFailure()
            }
        })
    }
    // MARK: - DELETE TO UnLike
    private func deleteLiked() {
        let reactionProvider = ReactionProvider()
        guard let tripId = trip?.id else { return }
        reactionProvider.deleteUnLiked(tripId: tripId, completion: { result in
            
            switch result {
                
            case .success: break
                
            case .failure:
                ProgressHUD.showFailure()
            }
        })
        
    }
}

extension ExploreDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ShareHeaderView.identifier)
                as? ShareHeaderView else { return nil }
        
        guard let trip = trip else { return nil }
        
        headerView.layoutHeaderView(data: trip)
        
        headerView.selectionView.delegate = self
        headerView.selectionView.dataSource = self
        
        headerView.collectClosure = { isCollected in
            guard KeyChainManager.shared.token != nil else { self.onShowLogin()
                return
            }
            self.postData(isCollected: isCollected, tripId: trip.id)
            self.trip?.isCollected = isCollected
            tableView.reloadData()
        }
        
        return headerView
    }
    
    // MARK: - Section Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        60.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ExploreDetailFooterView.identifier)
                as? ExploreDetailFooterView else { return nil }
        guard let trip = trip else { return nil }
        footerView.layoutFooterView(data: trip)
        
        footerView.collectClosure = { isCollected in
            guard KeyChainManager.shared.token != nil else { self.onShowLogin()
                return
            }
            self.postData(isCollected: isCollected, tripId: trip.id)
            self.trip?.isCollected = isCollected
            tableView.reloadData()
        }
        
        footerView.heartClosure = { isLiked in
            guard KeyChainManager.shared.token != nil else {  self.onShowLogin()
                return
            }
            
            if isLiked {
                self.postLiked()
                self.trip?.isLiked = isLiked
                self.trip?.likeCount += 1
                tableView.reloadData()
            } else {
                self.deleteLiked()
                self.trip?.isLiked = isLiked
                self.trip?.likeCount -= 1
                tableView.reloadData()
            }
            
        }
        
        footerView.copyClosure = { [weak self] in
            guard KeyChainManager.shared.token != nil else { self?.onShowLogin()
                return
            }
            guard let addPlanVC = UIStoryboard.planOverView.instantiateViewController(
                withIdentifier: StoryboardCategory.addPlanVC) as? AddPlanViewController else { return }
            addPlanVC.isCopiedTrip = true
            addPlanVC.copyTripId = self?.trip?.id
            addPlanVC.copyTextField = self?.trip?.title
            let navAddPlanVC = UINavigationController(rootViewController: addPlanVC)
            self?.present(navAddPlanVC, animated: true)
            
        }
        
        footerView.moveToCommentButton.addTarget(self, action: #selector(tapToCommentView), for: .touchUpInside)
        footerView.moveToCommentButton.setTitle("查看全部\(trip.commentCount)則留言", for: .normal)
        return footerView
    }
    
    @objc func tapToCommentView() {
        guard let commentVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.commentVC) as? CommentViewController else { return }
        commentVC.tripId = trip?.id
        let navCommentVC = UINavigationController(rootViewController: commentVC)
        
        self.present(navCommentVC, animated: true)
        
    }
    
    private func onShowLogin() {
        guard let authVC = UIStoryboard.auth.instantiateViewController(
            withIdentifier: StoryboardCategory.authVC) as? AuthViewController else { return }
        let navAuthVC = UINavigationController(rootViewController: authVC)
        present(navAuthVC, animated: true, completion: nil)
    }
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ExploreDetailTableViewCell.self), for: indexPath)
                as? ExploreDetailTableViewCell else { return UITableViewCell() }
        
        let item = schedule[indexPath.row]
        cell.layoutCell(data: item, index: indexPath.row)
        
        return cell
        
    }
    
}

extension ExploreDetailViewController: SegmentControlViewDataSource {
    
    func configureNumberOfButton(_ selectionView: SegmentControlView) -> Int {
        trip?.days ?? 1
    }
    
}

@objc extension ExploreDetailViewController: SegmentControlViewDelegate {
    func didSelectedButton(_ selectionView: SegmentControlView, at index: Int) {
        fetchData(days: index)
    }
}

extension ExploreDetailViewController {
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.registerHeaderWithNib(identifier: String(describing: ShareHeaderView.self), bundle: nil)
        tableView.registerCellWithNib(identifier: String(describing: ExploreDetailTableViewCell.self), bundle: nil)
        tableView.registerFooterWithNib(identifier: String(describing: ExploreDetailFooterView.self), bundle: nil)
    }
    
    private func setupNaviagtionBar() {
        self.navigationItem.title = "旅遊分享"
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        } else {
            tableView.tableHeaderView = UIView(
                frame: CGRect(x: .zero, y: .zero, width: .zero, height: CGFloat.leastNonzeroMagnitude))
        }
    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
}
