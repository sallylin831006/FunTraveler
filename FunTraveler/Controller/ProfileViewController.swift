//
//  ProfileViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/16.
//

import UIKit

class ProfileViewController: UIViewController {
    
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
        
        tableView.registerCellWithNib(identifier: String(describing: ExploreOverViewTableViewCell.self), bundle: nil)
        movingToCollectedPage()
    }
    
    func movingToCollectedPage() {
        let collectedButton = UIButton()
        collectedButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        collectedButton.backgroundColor = .themeRed
        collectedButton.addTarget(target, action: #selector(tapCollectedButton), for: .touchUpInside)
        self.tableView.addSubview(collectedButton)
    }

    @objc func tapCollectedButton() {
        guard let collectedVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.collectedVC) as? CollectedViewController else { return }
        let navCollectedVC = UINavigationController(rootViewController: collectedVC)
        // navExploreDeatilVC.modalPresentationStyle = .fullScreen
        self.present(navCollectedVC, animated: true)
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier)
                as? HeaderView else { return nil }
        
        headerView.titleLabel.text = "個人"
        
        return headerView
    }
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ExploreOverViewTableViewCell.self), for: indexPath)
                as? ExploreOverViewTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.dayTitleLabel.text = "5天| 旅遊回憶"
        cell.tripTitleLabel.text = "小琉球潛水趣"
        
        cell.planImageView.layer.borderColor = UIColor.themeApricotDeep?.cgColor
        cell.planImageView.layer.borderWidth = 3
        cell.planImageView.layer.cornerRadius = 10.0
        cell.planImageView.layer.masksToBounds = true
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
