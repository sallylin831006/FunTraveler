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

    var schedule: [Schedule] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var daySource: [DayModel] = []

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

        fetchData()
    }
    
    // MARK: - GET Action
    private func fetchData() {
        let tripProvider = TripProvider()
        
        guard let tripId = tripId else { return  }
        
        tripProvider.fetchSchedule(tripId: tripId, days: 1, completion: { [weak self] result in
            
            switch result {
                
            case .success(let tripSchedule):
                
                guard let schedules = tripSchedule.data.schedules else { return }
                
                self?.schedule = schedules[0]

//                guard let schedule = schedules.first else { return }
//
                print("[Explore Detail] GET schedule Detail:", tripSchedule)
                
            case .failure:
                print("[Explore Detail] GET schedule Detai 讀取資料失敗！")
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
        
        headerView.titleLabel.text = "看看別人的旅遊"
        headerView.selectionView.delegate = self
        headerView.selectionView.dataSource = self
//        headerView.dateLabel.text = "\(tripStartDate) - \(tripEndtDate)"
        
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
            
        }
        
        return footerView
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
        cell.durationLabel.text = String(schedule[indexPath.row].duration)
        
        if schedule[indexPath.row].images.isEmpty {
            cell.tripImage.backgroundColor = UIColor.themeApricotDeep
        } else {
            cell.tripImage.loadImage(schedule[indexPath.row].images.first)
            cell.tripImage.contentMode = .scaleAspectFill
        }
        
        cell.storiesTextLabel.text = schedule[indexPath.row].description
        
        return cell
        
    }
    
}

extension ExploreDetailViewController: SegmentControlViewDataSource {
    
    func configureNumberOfButton(_ selectionView: SegmentControlView) -> Int {
        //schedules.count HARD code
        3
    }
    
    func configureDetailOfButton(_ selectionView: SegmentControlView) -> [DayModel] {
        return daySource
        
    }

}

@objc extension ExploreDetailViewController: SegmentControlViewDelegate {
    func didSelectedButton(_ selectionView: SegmentControlView, at index: Int) {
        //fetchData(days: index)
    }
    
    func shouldSelectedButton(_ selectionView: SegmentControlView, at index: Int) -> Bool {
        return true
    }
}
