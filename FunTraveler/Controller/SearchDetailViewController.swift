//
//  SearchDetailViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/12.
//

import UIKit
//import GoogleMaps

class SearchDetailViewController: UIViewController {
    
    var searchResoponse: Results?
    
    var searchDetails: DetailResults? {
        
        didSet {
            
            tableView.reloadData()
            
        }
    }
    
    var tableView = UITableView() {
        
        didSet {
            
            tableView.dataSource = self
            
            tableView.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .systemYellow
        
        tableView.registerCellWithNib(identifier: String(describing: SearchDetailTableViewCell.self), bundle: nil)
        
        layoutOfTableView()
        // fetchData()
        
    }
    
    private func fetchData() {
        
        let searchProvider = SearchProvider()
        guard let placeId = searchResoponse?.placeId else { return }
        
        searchProvider.fetchSearchDetail(placeId: placeId, completion: { result in
            
            switch result {
                
            case .success(let searchDetails):
                
                self.searchDetails = searchDetails.result
                print("成功讀取資料！")
                
            case .failure:
                print("讀取資料失敗！")
            }
        })
        
    }
    
    func layoutOfTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        tableView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        
        tableView.heightAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
    }
}

extension SearchDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SearchDetailTableViewCell.self), for: indexPath)
                as? SearchDetailTableViewCell else { return UITableViewCell() }
        
        cell.nameLabel.text = searchDetails?.name
        cell.ratingLabel.text = "\(searchDetails?.rating ?? 0.0)"
        cell.addressLabel.text = searchDetails?.address
        cell.bussinessStatusLabel.text = searchDetails?.businessStatus
        // PHoto
        //        let searchProvider = SearchProvider()
        //        //沒有按照順序
        //        let photoReference = searchDetails?.photos[indexPath.row].photoReference ?? ref
        //        searchProvider.fetchPhotos(maxwidth: 400, photoreference: photoReference, completion: { result in
        //            cell.detailImageView.image = result
        //
        //        })
        
        return cell
        
    }
    
}
