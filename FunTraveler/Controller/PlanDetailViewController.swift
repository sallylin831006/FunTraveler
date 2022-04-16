//
//  ViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit
import GoogleMaps

class PlanDetailViewController: UIViewController {
    var schedules: [Schedule] = []
    var departureTime: String = ""
    var backTime: String = ""
    var tripTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addMap()
        showPlanPicker()
        addCustomBackButton()
        
    }
    
    func addCustomBackButton() {
        self.navigationItem.hidesBackButton = true
        let customBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                               style: UIBarButtonItem.Style.plain,
                                               target: self, action: #selector(backTap))
        customBackButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = customBackButton
    }
    
    @objc func backTap(_ sender: UIButton) {
        addAlert()
        
    }
    
    func addAlert() {
        let alertController = UIAlertController(title: "確定要返回嗎？", message: "現在返回所有編輯將會消失喔！", preferredStyle: .alert)
        
        let backAction = UIAlertAction(title: "忍痛放棄", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
        })
        
        alertController.addAction(backAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func showPlanPicker() {
        guard let planPickerViewController = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.planPickerVC) as? PlanPickerViewController else { return }
        
        planPickerViewController.scheduleClosure = { [weak self] schedules in
            self?.schedules = schedules
            self?.addMarker()
        }
        
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
        shareButton.addTarget(target, action: #selector(tapToShare), for: .touchUpInside)

        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.leadingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -70).isActive = true
        shareButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: 0).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    @objc func tapToShare() {
        guard let shareVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.shareVC) as? SharePlanViewController else { return }
        shareVC.schedules = schedules
        
        let navShareVC = UINavigationController(rootViewController: shareVC)
        //        navShareVC.modalPresentationStyle = .fullScreen
        self.present(navShareVC, animated: true)
    }
    
    let label = UILabel()
    let mapView = GMSMapView()

    func addMap() {
        mapView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(mapView)

        let camera = GMSCameraPosition.camera(withLatitude: 25.034012, longitude: 121.564461, zoom: 15.0)
        mapView.camera = camera
        
    }
    
    func addMarker() {
        var markerArray: [CLLocationCoordinate2D] = []
        mapView.clear()
        for schedule in schedules {
            
            let marker = GMSMarker()
            let markerView = UIImageView(image: UIImage.asset(.orderMarker))
            marker.iconView = markerView
            marker.position = CLLocationCoordinate2DMake(
                CLLocationDegrees(schedule.position.lat),
                CLLocationDegrees(schedule.position.long))
            
            marker.map = mapView
            marker.title = schedule.name
            marker.snippet = schedule.address
            markerArray.append(marker.position)
        }
        
        let path = GMSMutablePath()
        
        for coord in markerArray {
            path.add(coord)
        }
        let line = GMSPolyline(path: path)
        line.strokeColor = UIColor.themeRed!
        line.strokeWidth = 4.0
        line.map = mapView
    }
    
}
