//
//  ViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit
//import GoogleMaps

class PlanDetailViewController: UIViewController {
    
    var myTripId: Int?
    
    var trip: Trip?


    var schedules: [Schedule] = []
    
    var departureTime: String = ""
    var backTime: String = ""
    var tripTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addMap()
        showPlanPicker()
        addCustomBackButton()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
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
        let alertController = UIAlertController(title: "確定要離開編輯嗎？", message: "記得儲存您的旅遊規劃！", preferredStyle: .alert)
        
        let backAction = UIAlertAction(title: "儲存", style: .default, handler: { (_) in
            self.postData()
            
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            self.tabBarController?.tabBar.isHidden = false
            
        })
        
        let cancelAction = UIAlertAction(title: "繼續編輯", style: .cancel, handler: { (_) in
        })
        
        alertController.addAction(backAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Action
    private func postData() {
        
        let tripProvider = TripProvider()
        guard let tripId = myTripId else { return }
        
        if schedules.isEmpty { return }
        
        let day = schedules[0].day
        tripProvider.postTrip(tripId: tripId, schedules: schedules, day: day, completion: { result in
            
            switch result {
                
            case .success: break
                
            case .failure:
                print("[Plan Detail] POST TRIP DETAIL API讀取資料失敗！")
            }
        })
    }
    
    func showPlanPicker() {
        guard let planPickerViewController = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.planPickerVC) as? PlanPickerViewController else { return }
        planPickerViewController.myTripId = myTripId
        
        planPickerViewController.scheduleClosure = { [weak self] schedules in
            self?.schedules = schedules
//            self?.addMarker()
        }
        
        planPickerViewController.tripClosure = { [weak self] trip in
            self?.trip = trip
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
        shareButton.setTitleColor(.themeRed, for: .normal)
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
        
        if schedules.isEmpty {
            //  提醒請加入行程
            return
        }
        
        postData()
        
        guard let sharePlanVC = self.storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.shareVC) as? SharePlanViewController else { return }
        
        sharePlanVC.myTripId = myTripId

        let navSharePlanVC = UINavigationController(rootViewController: sharePlanVC)
        self.present(navSharePlanVC, animated: true)
        
    }
    
    func moveToSharePage() {
        
    }
    
//    let label = UILabel()
//    let mapView = GMSMapView()
//
//    func addMap() {
//        mapView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//        self.view.addSubview(mapView)
//
//        let camera = GMSCameraPosition.camera(withLatitude: 25.034012, longitude: 121.564461, zoom: 15.0)
//        mapView.camera = camera
        
    }
    
//    func addMarker() {
//        var markerArray: [CLLocationCoordinate2D] = []
//        mapView.clear()
//        for (index, schedule) in schedules.enumerated() {
//
//            let marker = GMSMarker()
//            let markerView = UIImageView(image: UIImage.asset(.orderMarker))
//            marker.iconView = markerView
//            marker.position = CLLocationCoordinate2DMake(
//                CLLocationDegrees(schedule.position.lat),
//                CLLocationDegrees(schedule.position.long))
//
//            marker.map = mapView
//            marker.title = schedule.name
//            marker.snippet = schedule.address
//            markerArray.append(marker.position)
//
//            let orderLabel = UILabel()
//            orderLabel.text = String(index + 1)
//            orderLabel.font = orderLabel.font.withSize(30)
//
//            orderLabel.textColor = UIColor.themeRed
//            marker.iconView?.addSubview(orderLabel)
//
//            orderLabel.translatesAutoresizingMaskIntoConstraints = false
//            orderLabel.topAnchor.constraint(
//                equalTo: marker.iconView!.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
//            orderLabel.centerXAnchor.constraint(equalTo: marker.iconView!.centerXAnchor).isActive = true
//        }
        
//        let path = GMSMutablePath()
//
//        for coord in markerArray {
//            path.add(coord)
//        }
//        let line = GMSPolyline(path: path)
//        line.strokeColor = UIColor.themeRed!
//        line.strokeWidth = 4.0
//        line.map = mapView
//    }
    
//}
