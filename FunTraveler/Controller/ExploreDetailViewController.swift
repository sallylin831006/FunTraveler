//
//  ExploreDetailViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/17.
//

import Foundation

import UIKit
class ExploreDetailViewController: UIViewController {
    
    var tripId: Int?
    //    {
    //        didSet {
    //            tableView.reloadData()
    //        }
    //    }
    //    var trip: Trip? {
    //        didSet {
    //            tableView.reloadData()
    //        }
    //    }
    //
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
        tableView.separatorStyle = .none
        tableView.registerHeaderWithNib(identifier: String(describing: HeaderView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: ExploreDetailTableViewCell.self), bundle: nil)
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
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier)
                as? HeaderView else { return nil }
        
        headerView.titleLabel.text = "看看別人的旅遊"
        
        return headerView
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
        cell.tripImage.backgroundColor = .red
        cell.storiesTextLabel.text = schedule[indexPath.row].description
        
        
        //
        //        cell.dayTitle.text = "\(exploreData[indexPath.row].days)天| 旅遊回憶"
        //        cell.tripTitle.text = exploreData[indexPath.row].title
        //
        //        cell.userName.text = exploreData[indexPath.row].user.name
        //
        //        cell.planImageView.layer.borderColor = UIColor.themeApricotDeep?.cgColor
        //        cell.planImageView.layer.borderWidth = 3
        //        cell.planImageView.layer.cornerRadius = 10.0
        //        cell.planImageView.layer.masksToBounds = true
        
        return cell
        
    }
    
}

