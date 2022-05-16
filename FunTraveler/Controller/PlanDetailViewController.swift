//
//  ViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/4/8.
//

import UIKit
import GoogleMaps

class PlanDetailViewController: UIViewController {
    
    var myTripId: Int?
    
    var trip: Trip?
    var currentDay: Int = 1
    var testcurrentDay: Int = 1

    var schedules: [Schedule] = []
    
    var departureTime: String = ""
    var backTime: String = ""
    var tripTitle: String = ""
    private let label = UILabel()
    private let mapView = GMSMapView()
    override func viewDidLoad() {
        super.viewDidLoad()
        addMap()
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
        self.postToSaveData(isFinished: false)
        
    }

    // MARK: - Action
    private func postToShareData(isFinished: Bool) {
        
        let tripProvider = TripProvider()
        guard let tripId = myTripId else { return }
        
        if schedules.isEmpty { return }
        
        let day = schedules[0].day
        tripProvider.postTrip(tripId: tripId, schedules: schedules, day: day, isFinished: isFinished, completion: { result in
            
            switch result {
                
            case .success:
                guard let sharePlanVC = self.storyboard?.instantiateViewController(
                    withIdentifier: StoryboardCategory.shareVC) as? SharePlanViewController else { return }
                
                sharePlanVC.myTripId = self.myTripId

                let navSharePlanVC = UINavigationController(rootViewController: sharePlanVC)
                self.present(navSharePlanVC, animated: true)
                
            case .failure:
                ProgressHUD.showFailure(text: "不能有行程是空的唷")
                print("[Plan Detail] POST TRIP DETAIL API讀取資料失敗！")
            }
        })
    }
    
    // MARK: - Action
    private func postToSaveData(isFinished: Bool) {
        
        let tripProvider = TripProvider()
        guard let tripId = myTripId else { return }

        let day = testcurrentDay
//        let day = schedules[0].day
        tripProvider.postTrip(tripId: tripId, schedules: schedules, day: day, isFinished: isFinished, completion: { result in
            
            switch result {
                
            case .success:
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
                self.tabBarController?.tabBar.isHidden = false
      
            case .failure:
                ProgressHUD.showFailure(text: "讀取失敗")
                print("[Plan Detail] POST TRIP DETAIL API讀取資料失敗！")
            }
        })
    }

    // MARK: - POST Action
    func postData(days: Int, isFinished: Bool) {
        let tripProvider = TripProvider()
        guard let tripId = myTripId else { return }
        tripProvider.postTrip(tripId: tripId, schedules: schedules, day: days, isFinished: isFinished, completion: { result in
            
            switch result {
                
            case .success:
                print("[PlanDetail] POST成功")
            case .failure:
//                ProgressHUD.showFailure(text: "讀取失敗")
                print("POST TRIP DETAIL API讀取資料失敗！")
            }
        })
    }
    
    
    
    func showPlanPicker() {
        guard let planPickerViewController = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.planPickerVC) as? PlanPickerViewController else { return }
        planPickerViewController.currentdayClosure = { currentday in
            self.testcurrentDay = currentday
        }
        planPickerViewController.myTripId = myTripId
        planPickerViewController.currentDay = currentDay
        planPickerViewController.scheduleClosure = { [weak self] schedules in
            self?.schedules = schedules
            self?.addMarker()
        }
        
        planPickerViewController.tripClosure = { [weak self] trip in
            self?.trip = trip
        }

        addChild(planPickerViewController)
        view.addSubview(planPickerViewController.view)

        
        // ADD BOTTOM VIEW
        let bottomView = UIView()
        let height = UIScreen.height/12
        bottomView.frame = CGRect(x: 0, y: UIScreen.height - height, width: UIScreen.width, height: height)
        bottomView.backgroundColor = UIColor.themeApricotDeep

        self.view.addSubview(bottomView)
        
        // ADD SHARE BUTTON
        let shareButton = UIButton()
//        shareButton.setTitleColor(.themeRed, for: .normal)

        shareButton.setBackgroundImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        shareButton.tintColor = UIColor.themePink
        bottomView.addSubview(shareButton)
        shareButton.addTarget(target, action: #selector(tapToShare), for: .touchUpInside)
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -24).isActive = true
        shareButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: -10).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //Add Schedule Button
        let searchButton = UIButton()
        bottomView.addSubview(searchButton)
        
        searchButton.backgroundColor = .themeRed
        searchButton.layer.cornerRadius = CornerRadius.buttonCorner
        searchButton.setTitle("+新增景點", for: .normal)
        searchButton.tintColor = UIColor.themeApricotDeep
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        searchButton.centerViewWithSize(searchButton, bottomView, width: 250, height: 35, centerXconstant: 0, centerYconstant: -10)
        searchButton.addTarget(target, action: #selector(tapScheduleButton), for: .touchUpInside)
    }
    @objc func tapScheduleButton() {
        
        guard let searchVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardCategory.searchVC) as? SearchViewController else { return }
        searchVC.scheduleArray = schedules
        
        if schedules.isEmpty {
            searchVC.day = 1
        } else {
            searchVC.day = schedules[0].day
        }
        
        searchVC.scheduleClosure = { [weak self] newSchedule in
            self?.schedules = newSchedule
            self?.postData(days: self!.testcurrentDay, isFinished: false)
            
        }
        let navSearchVC = UINavigationController(rootViewController: searchVC)
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

extension PlanDetailViewController {
    

    func addMap() {
        mapView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(mapView)

        let camera = GMSCameraPosition.camera(withLatitude: 25.034012, longitude: 121.564461, zoom: 15.0)
        mapView.camera = camera
        
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func addMarker() {
        
        var markerArray: [CLLocationCoordinate2D] = []
        mapView.clear()
        for (index, schedule) in schedules.enumerated() {

            let marker = GMSMarker()
//            let markerView = UIImageView(image: UIImage.asset(.orderMarker))
//            marker.iconView = markerView
//
            let markerView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 60))
            markerView.image =  UIImage.asset(.orderMarker)
            marker.iconView = markerView
//            marker.icon = self.imageWithImage(image: UIImage.asset(.orderMarker)!, scaledToSize: CGSize(width: 45.0, height: 60.0))

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
