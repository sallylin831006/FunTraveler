//
//  SearchViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/12.
//

import UIKit

class SearchViewController: UIViewController {
    
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
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // searchData.count
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SearchTableViewCell.self), for: indexPath)
                as? SearchTableViewCell else { return UITableViewCell() }
        
//        cell.nameLabel?.text = searchData[indexPath.row].name
//        cell.ratingLabel?.text = "★★★★☆\(searchData[indexPath.row].rating ?? 0.0)"
//        cell.addressLabel?.text = searchData[indexPath.row].vicinity
//        cell.searchData = searchData
        
        cell.actionBtn.addTarget(target, action: #selector(tapActionButton), for: .touchUpInside)
        
        // USER TAP ADD TO SCHEDULE
        cell.searchDataClosure = { cell in
//            print("成功加入行程！searchData:\(self.searchData[indexPath.row])", "indexPath:\(indexPath)")
            
            // POST API TO SEVER
            
        }
        
        return cell
        
    }
    
    @objc func tapActionButton() {
        print("成功加入行程！")
        //POST DATA: PlaceId name address 

    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let searchDetailVC = SearchDetailViewController()
        self.navigationController?.pushViewController(searchDetailVC, animated: true)
        searchDetailVC.searchResoponse = searchData[indexPath.row]
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
    func fetchSearchData(searchText: String) {
        let searchProvider = SearchProvider()
        
        searchProvider.fetchSearch(keyword: "\(searchText)",
        position: "25.0338,121.5646", radius: 1000, completion: { result in
            
            switch result {
                
            case .success(let searchData):
                
                self.searchData = searchData.results
                
            case .failure:
                print("讀取資料失敗！")
            }
        })
    }
    
}
