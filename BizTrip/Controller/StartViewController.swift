//
//  StartViewController.swift
//  BizTrip
//
//  Created by Carl Henningsson on 12/28/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import AVFoundation

class StartViewController: UIViewController {
    
    let location: UIButton = {
        let pD = UIButton(type: .custom)
        pD.setImage(UIImage(named: "location"), for: .normal)
        pD.addTarget(self, action: #selector(centerOnUser), for: .touchUpInside)
        
        return pD
    }()
    
    let locationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = SHADOW_COLOR
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 25
        
        return view
    }()
    
    let menuButton: UIButton = {
        let menu = UIButton(type: .custom)
        menu.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        menu.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        
        return menu
    }()
    
    let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = SHADOW_COLOR
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 25
        
        return view
    }()
    
    let journalButton: UIButton = {
        let journalBtn = UIButton(type: .custom)
        journalBtn.setImage(#imageLiteral(resourceName: "sports-car"), for: .normal)
        journalBtn.addTarget(self, action: #selector(showDriversJournal), for: .touchUpInside)
        
        return journalBtn
    }()
    
    let journalView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = SHADOW_COLOR
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 25
        
        return view
    }()
    
    let distansTracker: UILabel = {
        let dTracker = UILabel()
        dTracker.text = "0.0 km"
        dTracker.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        dTracker.textAlignment = .center
        dTracker.textColor = .white

        return dTracker
    }()
    
    let distansView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let dv: UIView = {
        let t = UIView()
        t.backgroundColor = .white
        t.layer.shadowColor = SHADOW_COLOR
        t.layer.shadowOffset = CGSize(width: 0, height: 2)
        t.layer.shadowOpacity = 1
        t.layer.cornerRadius = 25
        
        return t
    }()
    
    let mapView: MKMapView = {
        let mV = MKMapView()
        mV.mapType = .standard
        mV.isZoomEnabled = true
        mV.isRotateEnabled = true
        mV.showsUserLocation = true
        mV.showsScale = true
        mV.showsCompass = false
        
        return mV
    }()
    
    let goButton: UIButton = {
        let go = UIButton(type: .system)
        go.layer.cornerRadius = 50
        go.setTitle("Go", for: .normal)
        go.tintColor = .white
        go.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        go.layer.masksToBounds = true
        go.addTarget(self, action: #selector(startTrip), for: .touchUpInside)
        
        return go
    }()
    
    let stopButton: UIButton = {
        let stop = UIButton(type: .system)
        stop.layer.cornerRadius = 50
        stop.setTitle("Stop", for: .normal)
        stop.tintColor = .white
        stop.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        stop.layer.masksToBounds = true
        stop.alpha = 0
        stop.addTarget(self, action: #selector(stopTrip), for: .touchUpInside)
        
        return stop
    }()
    
    let goView: UIView = {
        let go = UIView()
        go.layer.cornerRadius = 50
        go.backgroundColor = .white
        go.layer.shadowColor = SHADOW_COLOR
        go.layer.shadowOffset = CGSize(width: 0, height: 2)
        go.layer.shadowOpacity = 1
        
        return go
    }()
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 500.0
    
    var startPosition: CLLocationCoordinate2D?
    var currentPosition: CLLocationCoordinate2D?
    var latestPosition: CLLocationCoordinate2D?
    var latestPositionDrawOnMap: CLLocationCoordinate2D?
    
    var currentCoordinates: CLLocation?
    var latestCoordinates: CLLocation?
    
    var totalDistance: Double = 0.0
    var distanceTicker: Double = 0.1
    
    var driveActivated = false
    
    let nsObject = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        configureLocationService()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentReachabilityStatus == .notReachable {
            noNetworkConnectionAlert()
        } else {
            checkForApplicationUpdate()
        }
    }
    
    private func vibrate() {
        let vibrate = SystemSoundID(1519)
        AudioServicesPlaySystemSound(vibrate)
    }
    
    func checkForApplicationUpdate() {
        if let appVersion = nsObject as? String {
            DataService.instance.REF_VERSION.observe(.value, with: { (snapshot) in
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshot {
                        if let version = snap.childSnapshot(forPath: "Version").value as? String {
                            if appVersion != version {
                                let updateController = UpdateController()
                                self.present(updateController, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }, withCancel: nil)
        }
    }
    
    private func noNetworkConnectionAlert() {
        let alert = UIAlertController(title: "No Network Connection", message: "BizTrip need a network connection to function correctly.", preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "Go To Settings", style: .default) { action in
            guard let settingURL = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL, completionHandler: { (sucess) in
                    print("Carl: setting opened sucessfully")
                })
            }
        }
        
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func startTrip() {
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            centerOnUser()
        } else if driveActivated == false {
            vibrate()
            
            UIView.animate(withDuration: 0.5) {
                self.goButton.alpha = 0
                self.stopButton.alpha = 1
            }
            
            let overlays = mapView.overlays
            mapView.removeOverlays(overlays)
            
            latestPosition = nil
            
            totalDistance = 0.0
            driveActivated = true
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            
            centerOnUser()
            self.mapView.setUserTrackingMode(.followWithHeading, animated: true)
            repteatFucnction()
            
            locationManager.startUpdatingLocation()
        }
    }
    
    func saveTripToFirebase(tripTitle: String) {
        
        var startLocation: String!
        var finishLocation: String!

        let timeStamp = Int(Date().timeIntervalSince1970)
        let roundedDistance = String(format: "%.1f", totalDistance)
        let finishPosition = locationManager.location?.coordinate

        let startAdressCoordinates = CLLocation(latitude: (startPosition?.latitude)!, longitude: (startPosition?.longitude)!)
        let finishAdressCoordinates = CLLocation(latitude: (finishPosition?.latitude)!, longitude: (finishPosition?.longitude)!)
        
        CLGeocoder().reverseGeocodeLocation(startAdressCoordinates) { (placemark, error) in
            if error != nil {
                startLocation = "Could not identify"
            } else {
                if let place = placemark?[0] {
                    if let street = place.thoroughfare {
                        if let streetNumber = place.subThoroughfare {
                            startLocation = "\(street) \(streetNumber)"
                        } else {
                            startLocation = "\(street)"
                        }
                        CLGeocoder().reverseGeocodeLocation(finishAdressCoordinates, completionHandler: { (placemark, error) in
                            if error != nil {
                                finishLocation = "Could not identify"
                            } else {
                                if let place = placemark?[0] {
                                    if let street = place.thoroughfare {
                                        if let streetNumber = place.subThoroughfare {
                                            finishLocation = "\(street) \(streetNumber)"
                                        } else {
                                            finishLocation = "\(street)"
                                        }
                                    } else {
                                        finishLocation = "Could not identify"
                                    }
                                }
                            }
                        })
                    } else {
                        startLocation = "Could not identify"
                    }
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let startLoc = startLocation, let finishLoc = finishLocation, let startLat = self.startPosition?.latitude, let startLong = self.startPosition?.longitude, let finishLat = finishPosition?.latitude, let finishLong = finishPosition?.longitude, let userUid = UserDefaults.standard.object(forKey: "UID") {
                    self.uploadTripToFirebase(user: "\(userUid)", timeStamp: timeStamp, distance: Double(roundedDistance)!, startLat: startLat, startLong: startLong, finishLat: finishLat, finishLong: finishLong, startAdress: startLoc, finishAdress: finishLoc, title: tripTitle)
            }
        }
        
        UIView.animate(withDuration: 0.5) {
            self.stopButton.alpha = 0
            self.goButton.alpha = 1
        }
        
        driveActivated = false
    }
    
    @objc private func stopTrip() {
        if driveActivated == true {
            vibrate()
            openTitleLauncher()
            self.mapView.setUserTrackingMode(.follow, animated: true)
        }
    }
    
    func uploadTripToFirebase(user: String, timeStamp: Int, distance: Double, startLat: Double, startLong: Double, finishLat: Double, finishLong: Double, startAdress: String, finishAdress: String, title: String) {
        let tripInformation: Dictionary = [
            "timeStamp": timeStamp,
            "distance": distance,
            "startLatitude": startLat,
            "startLongitude": startLong,
            "finishLatitude": finishLat,
            "finishLongitude": finishLong,
            "startAdress": startAdress,
            "finishAdress": finishAdress,
            "titel": title
            ] as [String : Any]
        DataService.instance.REF_USER.child("\(user)").child("trips").childByAutoId().updateChildValues(tripInformation)
    }
    
    @objc func centerOnUser() {
        let noAuthorization = UIAlertController(title: "Always Allow Location", message: "For BizTrip to work properly in the background while you are driving you need to \"always allow\" location access. \nFor more information visit https://support.apple.com/en-us/HT207056", preferredStyle: .alert)
        let openSetting = UIAlertAction(title: "Go to Setting", style: .default) { action in
            guard let settingURL = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL, completionHandler: { (sucess) in
                    print("Carl: setting opened sucessfully")
                })
            }
        }
        
        noAuthorization.addAction(openSetting)
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            centerMapOnUser()
            self.mapView.setUserTrackingMode(.follow, animated: true)
        } else {
            self.present(noAuthorization, animated: true, completion: nil)
        }
    }
    
    func repteatFucnction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.calculateDistance()
        }
    }
    
    @objc func calculateDistance() {
        if let cLocation = locationManager.location?.coordinate {
            if latestPosition != nil {
                latestPosition = currentPosition
                currentPosition = cLocation
                
                latestCoordinates = CLLocation(latitude: (latestPosition?.latitude)!, longitude: (latestPosition?.longitude)!)
                currentCoordinates = CLLocation(latitude: (currentPosition?.latitude)!, longitude: (currentPosition?.longitude)!)
                
                totalDistance = totalDistance + ((latestCoordinates?.distance(from: currentCoordinates!))! / 1000)
                
                let roundedDistance = String(format: "%.1f", totalDistance)
                distansTracker.text = "\(roundedDistance) km"
                
                if distanceTicker == 0.1 || totalDistance > distanceTicker {
                    drawOnMap()
                    distanceTicker += 0.1
                }
                
            } else {
                startPosition = cLocation
                currentPosition = cLocation
                latestPosition = currentPosition
                
                totalDistance = 0.0
            }
            
            if driveActivated == true {
                repteatFucnction()
            }
        }
    }
    
    func drawOnMap() {
        if let cLocation = locationManager.location?.coordinate {
            if mapView.overlays.count == 0 {
                latestPositionDrawOnMap = cLocation
            }
            
            let latestPlacemark = MKPlacemark(coordinate: latestPositionDrawOnMap!)
            let currentPlacemark = MKPlacemark(coordinate: currentPosition!)
            
            let latestItem = MKMapItem(placemark: latestPlacemark)
            let currentItem = MKMapItem(placemark: currentPlacemark)
            
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = latestItem
            directionRequest.destination = currentItem
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                guard let response = response else { return }
                let route = response.routes[0]
                self.mapView.add(route.polyline, level: .aboveRoads)
            }
            
            latestPositionDrawOnMap = currentPosition
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = MAIN_BLUE_COLOR
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    @objc func showDriversJournal() {
        let driversJournalController = DriversJournalController()
        present(driversJournalController, animated: true, completion: nil)
    }
    
    lazy var menuLauncher: MenuLauncher = {
        let menu = MenuLauncher()
        menu.startViewController = self
        
        return menu
    }()
    
    lazy var feedbackLauncher: FeedbackLauncher = {
        let feedback = FeedbackLauncher()
        feedback.startViewController = self
        
        return feedback
    }()
    
    lazy var titleLauncher: TitleLauncher = {
        let title = TitleLauncher()
        title.startViewController = self
        
        return title
    }()
    
    @objc func openMenu() {
        menuLauncher.showMenu()
    }
    
    func openFeedbackLauncher() {
        feedbackLauncher.showFeedback()
    }
    
    func openTitleLauncher() {
        titleLauncher.showTitle()
    }
    
    func openTermsController() {
        let termsController = TermsController()
        present(termsController, animated: true, completion: nil)
    }
    
    func shareApplication() {
        var shareItem = [] as [Any]
        
        let text = "I'm using BizTrip as my drive journal, try it you too!"
        let url = "https://itunes.apple.com/se/app/biztrip-drive-journal/id1369703392?l=en&mt=8"
        
        shareItem = [text, url]
        
        let shareController = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
        shareController.popoverPresentationController?.sourceView = self.view
        self.present(shareController, animated: true, completion: nil)
    }
    
    func setupView() {
        let sideConstant = view.frame.width / 30
        
        view.addSubview(mapView)
        
        view.addSubview(dv)
        view.addSubview(distansView)
        distansView.addSubview(distansTracker)
        view.addSubview(locationView)
        locationView.addSubview(location)
        
        view.addSubview(menuView)
        menuView.addSubview(menuButton)
        view.addSubview(goView)
        view.addSubview(goButton)
        view.addSubview(stopButton)
        view.addSubview(journalView)
        journalView.addSubview(journalButton)
        
        _ = mapView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        dv.frame = CGRect(x: sideConstant, y: 50, width: 150, height: 50)
        distansView.frame = CGRect(x: sideConstant, y: 50, width: 150, height: 50)
        _ = distansTracker.anchor(distansView.topAnchor, left: distansView.leftAnchor, bottom: distansView.bottomAnchor, right: distansView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        locationView.frame = CGRect(x: view.frame.width - sideConstant - 50, y: 50, width: 50, height: 50)
        _ = location.anchor(locationView.topAnchor, left: locationView.leftAnchor, bottom: locationView.bottomAnchor, right: locationView.rightAnchor, topConstant: 12.5, leftConstant: 12.5, bottomConstant: 12.5, rightConstant: 12.5, widthConstant: 0, heightConstant: 0)
        
        _ = menuView.anchor(nil, left: view.leftAnchor, bottom: goButton.bottomAnchor, right: nil, topConstant: 0, leftConstant: view.frame.width / 3 - 75, bottomConstant: 25, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        _ = menuButton.anchor(menuView.topAnchor, left: menuView.leftAnchor, bottom: menuView.bottomAnchor, right: menuView.rightAnchor, topConstant: 15, leftConstant: 15, bottomConstant: 15, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        goButton.frame = CGRect(x: view.frame.midX - 50, y: view.frame.height - 150, width: 100, height: 100)
        stopButton.frame = CGRect(x: view.frame.midX - 50, y: view.frame.height - 150, width: 100, height: 100)
        goView.frame = CGRect(x: view.frame.midX - 50, y: view.frame.height - 150, width: 100, height: 100)
        _ = journalView.anchor(nil, left: nil, bottom: goButton.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 25, rightConstant: view.frame.width / 3 - 75, widthConstant: 50, heightConstant: 50)
        _ = journalButton.anchor(journalView.topAnchor, left: journalView.leftAnchor, bottom: journalView.bottomAnchor, right: journalView.rightAnchor, topConstant: 12.5, leftConstant: 12.5, bottomConstant: 12.5, rightConstant: 12.5, widthConstant: 0, heightConstant: 0)

        
        distansView.setGradientColor(colorOne: greenTopColor, colorTwo: greenBottomColor)
        goButton.setGradientColor(colorOne: greenTopColor, colorTwo: greenBottomColor)
        stopButton.setGradientColor(colorOne: redTopColor, colorTwo: redBottomColor)
    }
}

extension StartViewController: MKMapViewDelegate {
    func centerMapOnUser() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension StartViewController: CLLocationManagerDelegate {
    func configureLocationService() {
        if authorizationStatus == .authorizedAlways {
            return
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .restricted, .denied:
            print("Carl: denied")
            break
        case .authorizedWhenInUse:
            centerMapOnUser()
            break
        case .authorizedAlways:
            centerMapOnUser()
            break
        case .notDetermined:
            break
        }
    }
}

extension String {
    var wordList: [String] {
        return components(separatedBy: " D ")
            .joined(separator: ", ")
            .components(separatedBy: "")
    }
}
