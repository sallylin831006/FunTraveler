//
//  SearchViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/12.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    var scheduleArray: [Schedule] = []
    var day: Int = 1
    
    private var newTrafficTime: Double = 1.0
    
    var scheduleClosure : ((_ schedules: [Schedule]) -> Void)?
    
    var searchData: [Results] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: String(describing: SearchTableViewCell.self), bundle: nil)
        
        searchBar.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        scheduleClosure?(scheduleArray)
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SearchTableViewCell.self), for: indexPath)
                as? SearchTableViewCell else { return UITableViewCell() }
        cell.nameLabel?.text = searchData[indexPath.row].name
        cell.ratingLabel?.text = "★★★★☆\(searchData[indexPath.row].rating ?? 0.0)"
        cell.addressLabel?.text = searchData[indexPath.row].vicinity
        cell.searchData = searchData
        
        cell.actionBtn.addTarget(target, action: #selector(tapActionButton), for: .touchUpInside)
        
//         USER TAP ADD TO SCHEDULE IMPORTANT!
//        cell.searchDataClosure = { searchData in
//            print("成功加入行程！searchData:\(self.searchData[indexPath.row])", "indexPath:\(indexPath)")
//
//        }
        
        return cell
        
    }

    @objc func tapActionButton(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }

        let schedule = Schedule(
            name: searchData[indexPath.row].name,
            day: day,
            address: searchData[indexPath.row].vicinity,
            startTime: "09:00", duration: 1.0,
            trafficTime: newTrafficTime,
            type: "attraction",
            position: Position(
                lat: Double(searchData[indexPath.row].geometry.location.lat),
                long: Double(searchData[indexPath.row].geometry.location.lng)
            )
        )
        scheduleArray.append(schedule)
        print("成功加入行程！！")
        
        if indexPath.row == 0 {
            newTrafficTime = 0.5
            return
        }
        // calculate time
        let coordinate₀ = CLLocation(
            latitude: Double(searchData[indexPath.row-1].geometry.location.lat),
            longitude: Double(searchData[indexPath.row-1].geometry.location.lat)
        )
        let coordinate₁ = CLLocation(
            latitude: Double(searchData[indexPath.row].geometry.location.lat),
            longitude: Double(searchData[indexPath.row].geometry.location.lat)
        )

        let distance = coordinate₀.distance(from: coordinate₁)/1000
        
        newTrafficTime = Double(distance.rounding(toDecimal: 2)/60)
        // 距離約ＸＸ公里，開車約 X分鐘
    }
            
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let searchDetailVC = SearchDetailViewController()
//        self.navigationController?.pushViewController(searchDetailVC, animated: true)
//        searchDetailVC.searchResoponse = searchData[indexPath.row]
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchSearchData(searchText: searchText)
    }
    
    // MARK: - Action
    private func fetchSearchData(searchText: String) {
        let searchProvider = SearchProvider()
        if searchText == "" { return }
        searchProvider.fetchSearch(keyword: "\(searchText)",
        position: "25.0338,121.5646", radius: 1000, completion: { result in
            
            switch result {
                
            case .success(let searchData):
                
                self.searchData = searchData.results
                
            case .failure:
                print("searchProvider讀取資料失敗！")
            }
        })
    }
    
}
