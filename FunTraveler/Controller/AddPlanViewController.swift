//
//  AddPlanViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit
import IQKeyboardManagerSwift

class AddPlanViewController: UIViewController, UITextFieldDelegate {
    
    var tripIdClosure: ((_ tripId: Int) -> Void)?
    
    var tripId: Int?

    private var startDate: String?
    
    private var endDate: String?
    
    private var titleText: String?
    
    var textFieldClosure : ((_ text: String) -> Void)? {
        
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
        
        tableView.registerHeaderWithNib(identifier: String(describing: HeaderView.self), bundle: nil)
        
        tableView.registerFooterWithNib(identifier: String(describing: FooterView.self), bundle: nil)
        
        tableView.registerCellWithNib(identifier: String(describing: AddPlanTableViewCell.self), bundle: nil)
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40
        tableView.shouldIgnoreScrollingAdjustment = true
    }
    
}

extension AddPlanViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderView.identifier)
                as? HeaderView else { return nil }
        
        headerView.titleLabel.text = "建立行程"
        
        return headerView
    }
    
    // MARK: - Section Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        150.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: FooterView.identifier)
                as? FooterView else { return nil }
        
        footerView.saveButton.addTarget(target, action: #selector(tapSaveButton), for: .touchUpInside)
        
        footerView.cancelButton.addTarget(target, action: #selector(tapCancelButton), for: .touchUpInside)
        
        return footerView
    }
    
    @objc func tapSaveButton() {
        postData()
        guard let planDetailViewController = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.planDetailVC) as? PlanDetailViewController else { return }
        textFieldClosure = { titleText in
            planDetailViewController.tripTitle = titleText
        }
        
        tripIdClosure = { tripId in
            planDetailViewController.tripId = tripId
        }
        navigationController?.pushViewController(planDetailViewController, animated: true)
        
    }
    
    // MARK: - POST API TO ADD NEW TRIP
        private func postData() {
            let tripProvider = TripProvider()
            guard let titleText = titleText,
                  let startDate = startDate,
                  let endDate = endDate else { return }
            
            tripProvider.addTrip(title: titleText,
                                 startDate: startDate,
                                 endDate: endDate,
                                 completion: { result in
                
                switch result {
                    
                case .success(let tripIdResponse):
                
                    self.tripIdClosure?(tripIdResponse.data.id)
                    
                case .failure:
                    print("tripIdResponse讀取資料失敗！")
                }
            })
            
        }
    
    @objc func tapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Section Row
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: AddPlanTableViewCell.self), for: indexPath)
                as? AddPlanTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.titleDelegate = self
        
        cell.departurePickerVIew.dateClosure = { [weak self] startDate in
            self?.startDate = startDate
        }

        cell.backPickerVIew.dateClosure = { [weak self] endDate in
            self?.endDate =  endDate
        }
        
        return cell
        
    }
    
}

extension AddPlanViewController: AddPlanTableViewCellDelegate {
    
    func didChangeTitleData(_ cell: AddPlanTableViewCell, text: String) {
        
        self.titleText = text
        
//        guard let textFieldClosure = textFieldClosure else { return }
//        textFieldClosure(text) //closeure尚未生成，因此被RETURN
    }
    
}
