//
//  ViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var tripId: Int?
    var trip: Trip?
    var currentDay: Int = 1
    var schedules: [Schedule] = []
    
    private let mapView = GMSMapView()
    private let bottomView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        addMap()
        showPlanPicker()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.postToSaveData(isFinished: false)
    }
    
    func showPlanPicker() {
        guard let planPickerViewController = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.planPickerVC) as? PlanPickerViewController else { return }
        planPickerViewController.tripId = tripId
        planPickerViewController.currentdayClosure = { currentday in
            self.currentDay = currentday
        }
        planPickerViewController.scheduleClosure = { [weak self] schedules in
            self?.schedules = schedules
            self?.addMarker()
        }
        planPickerViewController.tripClosure = { [weak self] trip in
            self?.trip = trip
        }
        addChild(planPickerViewController)
        view.addSubview(planPickerViewController.view)
        
    }
    
    @objc func tapScheduleButton() {
        
        guard let searchViewController = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.searchVC) as? SearchViewController else { return }
        searchViewController.scheduleArray = schedules
        
        if schedules.isEmpty {
            searchViewController.currentDay = 1
        } else {
            searchViewController.currentDay = schedules[0].day
        }
        
        searchViewController.scheduleClosure = { [weak self] newSchedule in
            self?.schedules = newSchedule
            self?.postData(days: self!.currentDay, isFinished: false)
        }
        let navSearchVC = UINavigationController(rootViewController: searchViewController)
        self.present(navSearchVC, animated: true)
    }
    
    @objc func tapToShare() {
        if schedules.isEmpty {
            ProgressHUD.showFailure(text: "不能有行程是空的唷")
            return
        }
        postToShareData(isFinished: true)
    }
}

extension MapViewController {
    // MARK: - Action
    private func postToShareData(isFinished: Bool) {
        
        let tripProvider = TripProvider()
        guard let tripId = tripId else { return }
        
        if schedules.isEmpty { return }
        
        let day = schedules[0].day
        tripProvider.postTrip(tripId: tripId, schedules: schedules, day: day,
                              isFinished: isFinished, completion: { [weak self] result in
            
            switch result {
                
            case .success:
                guard let sharePlanVC = self?.storyboard?.instantiateViewController(
                    withIdentifier: StoryboardCategory.shareVC) as? SharePlanViewController else { return }
                
                sharePlanVC.myTripId = self?.tripId
                
                let navSharePlanVC = UINavigationController(rootViewController: sharePlanVC)
                self?.present(navSharePlanVC, animated: true)
                
            case .failure:
                ProgressHUD.showFailure(text: "不能有行程是空的唷")
            }
        })
    }
    
    // MARK: - Action
    private func postToSaveData(isFinished: Bool) {
        
        let tripProvider = TripProvider()
        guard let tripId = tripId else { return }
        
        let day = currentDay
        tripProvider.postTrip(tripId: tripId, schedules: schedules, day: day,
                              isFinished: isFinished, completion: { result in
            
            switch result {
                
            case .success:
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
                self.tabBarController?.tabBar.isHidden = false
                
            case .failure:
                ProgressHUD.showFailure()
            }
        })
    }
    
    // MARK: - POST Action
    func postData(days: Int, isFinished: Bool) {
        let tripProvider = TripProvider()
        guard let tripId = tripId else { return }
        tripProvider.postTrip(tripId: tripId, schedules: schedules, day: days,
                              isFinished: isFinished, completion: { result in
            
            switch result {
                
            case .success:
                print("[PlanDetail] POST成功")
            case .failure:
                print("POST TRIP DETAIL API讀取資料失敗！")
            }
        })
    }
}

extension MapViewController {
    func addMap() {
        mapView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(mapView)
        let camera = GMSCameraPosition.camera(withLatitude: 25.034012, longitude: 121.564461, zoom: 15.0)
        mapView.camera = camera
    }

    func addMarker() {
        var markerArray: [CLLocationCoordinate2D] = []
        mapView.clear()
        for (index, schedule) in schedules.enumerated() {
            
            let marker = GMSMarker()
            let markerView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 60))
            markerView.image =  UIImage.asset(.orderMarker)
            marker.iconView = markerView
            
            marker.position = CLLocationCoordinate2DMake(
                CLLocationDegrees(schedule.position.lat),
                CLLocationDegrees(schedule.position.long))
            
            marker.map = mapView
            marker.title = schedule.name
            marker.snippet = schedule.address
            markerArray.append(marker.position)
            
            let orderLabel = UILabel()
            orderLabel.text = String(index + 1)
            orderLabel.font = orderLabel.font.withSize(15)
            
            orderLabel.textColor = UIColor.themeRed
            markerView.addSubview(orderLabel)
            
            orderLabel.translatesAutoresizingMaskIntoConstraints = false
            orderLabel.topAnchor.constraint(
                equalTo: markerView.layoutMarginsGuide.topAnchor, constant: 5).isActive = true
            orderLabel.centerXAnchor.constraint(equalTo: markerView.centerXAnchor).isActive = true
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

extension MapViewController {
    func setupUI() {
        setupBottomView()
        setupShareButton()
        setupSearchButton()
    }
    
    func setupBottomView() {
        let height = UIScreen.height/12
        bottomView.frame = CGRect(x: 0, y: UIScreen.height - height, width: UIScreen.width, height: height)
        bottomView.backgroundColor = UIColor.themeApricotDeep
        self.view.addSubview(bottomView)
    }
    
    func setupShareButton() {
        let shareButton = UIButton()
        shareButton.setBackgroundImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        shareButton.tintColor = UIColor.themePink
        bottomView.addSubview(shareButton)
        shareButton.addTarget(target, action: #selector(tapToShare), for: .touchUpInside)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -24).isActive = true
        shareButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: -10).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupSearchButton() {
        let searchButton = UIButton()
        bottomView.addSubview(searchButton)
        searchButton.backgroundColor = .themeRed
        searchButton.layer.cornerRadius = CornerRadius.buttonCorner
        searchButton.setTitle("+新增景點", for: .normal)
        searchButton.tintColor = UIColor.themeApricotDeep
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        searchButton.centerViewWithSize(searchButton, bottomView, width: 250, height: 35,
                                        centerXconstant: 0, centerYconstant: -10)
        searchButton.addTarget(target, action: #selector(tapScheduleButton), for: .touchUpInside)
    }
    
}
