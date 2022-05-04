//
//  BlockListViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/4.
//

import UIKit

class BlockListViewController: UIViewController {
    
    let containerView: UIView = {
        let view = UIView()
        return view }()
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.register(
            UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        setupTableView()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor.white

        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        //            fetchData()
        //            tableView.reloadData()
    }
}

extension BlockListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "已封鎖的使用者"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        50
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "黑名單"
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension BlockListViewController {
    func setupContainerView() {
        
        containerView.stickSafeArea(containerView, view)
    }
    
    func setupTableView() {
        tableView.stickView(tableView, containerView)
    }
    
}
