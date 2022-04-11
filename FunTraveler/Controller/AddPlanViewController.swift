//
//  AddPlanViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/11.
//

import UIKit

class AddPlanViewController: UIViewController {
    
    var textFieldClosure : ((_ text: String) -> Void)? {
        
        didSet {
            
            tableView.reloadData()
            
        }
    }
    
    var departureTime: String = ""
    var backTime: String = ""
    var tripTitle: String = "" 
    
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
        50.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: FooterView.identifier)
                as? FooterView else { return nil }
        
        footerView.saveButton.addTarget(target, action: #selector(tapSaveButton), for: .touchUpInside)
        
        footerView.cancelButton.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
        
        return footerView
    }
    
    @objc func tapSaveButton() {
   
        guard let planDetailViewController = storyboard?.instantiateViewController(
            withIdentifier: UIStoryboard.planDetailVC) as? PlanDetailViewController else { return }
        planDetailViewController.departureTime = departureTime
        planDetailViewController.backTime = backTime
//        planDetailViewController.tripTitle = tripTitle
        
        textFieldClosure = { titleText in
            print("成功了嗎", titleText)
        }
        
        print("tripTitle", tripTitle)
        navigationController?.pushViewController(planDetailViewController, animated: true)
        navigationController?.modalPresentationStyle = .fullScreen
        present(planDetailViewController, animated: true, completion: nil)
        
    }
    
    @objc func tapCancelButton() {
        //不知為何沒有進來這個func
        print("進來喔")
        dismiss(animated: true, completion: nil)
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
        
        // pickerView傳值到VC
        cell.departurePickerVIew.dateClosure = { departureTime in
            self.departureTime = departureTime
        }
        cell.backPickerVIew.dateClosure = { backTime in
            self.backTime = backTime
        }
        
        //titleTextfield NotWorking
        tripTitle = cell.textField.text ?? ""
        
        cell.titleClosure = { titleText in
            print("titleText", titleText)
        }
        
//        textFieldClosure(cell.textField.text ?? "")
        
//        cell.passTitleData(tripTitle: tripTitle)
    
        return cell
        
    }

}
