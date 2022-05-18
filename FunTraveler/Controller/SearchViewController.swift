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
    var currentDay: Int = 1
    
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
        searchBar.placeholder = "搜尋景點..."
        searchBar.layer.borderWidth = 2
        searchBar.layer.borderColor = UIColor.themeApricot?.cgColor
        searchBar.barTintColor = .themeApricot
        searchBar.searchTextField.backgroundColor = .white
        
        tableView.registerCellWithNib(identifier: String(describing: SearchTableViewCell.self), bundle: nil)
        tableView.separatorColor = .themeApricotDeep
        searchBar.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        let item = searchData[indexPath.row]
        cell.layoutCell(data: item, index: indexPath.row)
        
        cell.delegate = self

        return cell
        
    }
    
}

extension SearchViewController: SearchTableViewCellDelegate {
    func addNewSchedule(_ sender: UIButton) {
        showSuccessView()
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }

        let schedule = Schedule(
            name: searchData[indexPath.row].name,
            day: currentDay,
            address: searchData[indexPath.row].vicinity,
            startTime: "09:00", duration: 1.0,
            trafficTime: 0,
            type: "attraction",
            position: Position(
                lat: Double(searchData[indexPath.row].geometry.location.lat),
                long: Double(searchData[indexPath.row].geometry.location.lng)
            )
        )
        if scheduleArray.isEmpty {
            scheduleArray.append(schedule)
            return
            
        }

        scheduleArray.append(schedule)
        print("成功加入行程！！")
        
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
        position: "25.0338,121.5646", radius: 100000, completion: { result in
            
            switch result {
                
            case .success(let searchData):
                
                self.searchData = searchData.results
                
            case .failure:
//                ProgressHUD.showFailure(text: "讀取失敗")
                print("searchProvider讀取資料失敗！")
            }
        })
    }
    
}

extension SearchViewController {
    private func showSuccessView() {
        let successView = SuccessView()
        successView.centerViewWithSize(successView, view, width: 200, height: 200)
    }
}
