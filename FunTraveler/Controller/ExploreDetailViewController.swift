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
    
//    var commentData: [Comment] = [] {
//        didSet {
//            tableView.reloadData()
//        }
//    }

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.registerHeaderWithNib(identifier: String(describing: ShareHeaderView.self), bundle: nil)

        tableView.registerCellWithNib(identifier: String(describing: ExploreDetailTableViewCell.self), bundle: nil)
        
        tableView.registerFooterWithNib(identifier: String(describing: ExploreDetailFooterView.self), bundle: nil)

        fetchData(days: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "旅遊分享"
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        } else {
            tableView.tableHeaderView = UIView(
                frame: CGRect(x: .zero, y: .zero, width: .zero, height: CGFloat.leastNonzeroMagnitude))
        }

        addCustomBackButton()

    }
    func addCustomBackButton() {
        self.navigationItem.hidesBackButton = true

        let customBackButton = UIBarButtonItem(image: UIImage(
            systemName: "chevron.backward"), style: UIBarButtonItem.Style.plain,
                                               target: self, action: #selector(backTap))
        customBackButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = customBackButton
    }
    @objc func backTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
    }

    // MARK: - GET Action
    private func fetchData(days: Int) {
        let tripProvider = TripProvider()
        
        guard let tripId = tripId else { return }
//        guard let days = days else { return }

        tripProvider.fetchSchedule(tripId: tripId, days: days, completion: { [weak self] result in
            
            switch result {
                
            case .success(let tripSchedule):
                
                guard let schedules = tripSchedule.data.schedules else { return }
                
                self?.trip = tripSchedule.data

                self?.schedule = schedules.first ?? []
                   
            case .failure:
                print("[Explore Detail] GET schedule Detai 讀取資料失敗！")
            }
        })
        
    }
    
//    // MARK: - GET Action
//    private func fetchCommentData() {
//
//        let reactionProvider = ReactionProvider()
//        guard let tripId = tripId else { return }
//        reactionProvider.fetchComment(tripId: tripId, completion: { [weak self] result in
//
//            switch result {
//
//            case .success(let commentData):
//
//                self?.commentData = commentData.data
//
//                print("commentData", commentData)
//
//            case .failure:
//                print("[CommentVC] GET 讀取資料失敗！")
//            }
//        })
//    }
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
        guard let tripTitle = trip?.title else { return nil }
        headerView.titleLabel.text = tripTitle
        headerView.selectionView.delegate = self
        headerView.selectionView.dataSource = self
        
        guard let tripStartDate = trip?.startDate else { return nil }
        guard let tripEndtDate = trip?.endDate else { return nil }
        headerView.dateLabel.text = "\(tripStartDate) - \(tripEndtDate)"
        
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
        
        footerView.copyClosure = { [weak self] in
            print("一鍵複製行程！")
//            self?.postCopyTrip()
            guard let addPlanVC = UIStoryboard.planOverView.instantiateViewController(
                withIdentifier: StoryboardCategory.addPlanVC) as? AddPlanViewController else { return }
            addPlanVC.isCopiedTrip = true
            addPlanVC.copyTripId = self?.trip?.id
            addPlanVC.copyTextField = self?.trip?.title
            let navAddPlanVC = UINavigationController(rootViewController: addPlanVC)
            //  navAddPlanVC.modalPresentationStyle = .fullScreen
            self?.present(navAddPlanVC, animated: true)
            
        }
        
        footerView.moveToCommentButton.addTarget(self, action: #selector(tapToCommentView), for: .touchUpInside)
        guard let numberOfComment = trip?.commentCount else { return nil}
        footerView.moveToCommentButton.setTitle("查看全部\(numberOfComment)則留言", for: .normal)
        return footerView
    }
    
    @objc func tapToCommentView() {
        guard let commentVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.commentVC) as? CommentViewController else { return }
        commentVC.tripId = trip?.id
//        commentVC.commentData = commentData
        let navCommentVC = UINavigationController(rootViewController: commentVC)

        self.present(navCommentVC, animated: true)
     
    }
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ExploreDetailTableViewCell.self), for: indexPath)
                as? ExploreDetailTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.orderLabel.text = String(indexPath.row + 1)
        cell.nameLabel.text = schedule[indexPath.row].name
        cell.addressLabel.text = schedule[indexPath.row].address
        cell.durationLabel.text = "停留時間：\(schedule[indexPath.row].duration)"
        
        if schedule[indexPath.row].images.isEmpty {
            cell.tripImage.image = nil
            cell.tripImage.backgroundColor = UIColor.themeApricotDeep
        } else {
            cell.tripImage.loadImage(schedule[indexPath.row].images.first, placeHolder: UIImage.asset(.imagePlaceholder))
            cell.tripImage.contentMode = .scaleAspectFill
        }
        
        if schedule[indexPath.row].description.isEmpty {
            cell.storiesTextLabel.text = nil
        } else {
            cell.storiesTextLabel.text = schedule[indexPath.row].description
        }
        
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
    
    func shouldSelectedButton(_ selectionView: SegmentControlView, at index: Int) -> Bool {
        return true
    }
}
