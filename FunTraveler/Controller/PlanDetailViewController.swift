//
//  ViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit

class PlanDetailViewController: UIViewController {
    
    var departureTime: String = ""
    var backTime: String = ""
    var tripTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPlanPicker()
        self.navigationItem.hidesBackButton = true
    }

    func showPlanPicker() {
        guard let planPickerViewController = storyboard?.instantiateViewController(
            withIdentifier: UIStoryboard.planPickerVC) as? PlanPickerViewController else { return }
        planPickerViewController.departureTime = departureTime
        planPickerViewController.backTime = backTime
        planPickerViewController.tripTitle = tripTitle

        addChild(planPickerViewController)
        view.addSubview(planPickerViewController.view)
        
        // ADD BOTTOM VIEW
        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0, y: UIScreen.height - 80, width: UIScreen.width, height: 80)
        bottomView.backgroundColor = UIColor.themeApricotDeep
        self.view.addSubview(bottomView)
        
        // ADD SHARE BUTTON
        let shareButton = UIButton()
        shareButton.backgroundColor = .lightGray
        shareButton.setTitle("分享", for: .normal)
        bottomView.addSubview(shareButton)

        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.leadingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -70).isActive = true
        shareButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: 0).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }

}
