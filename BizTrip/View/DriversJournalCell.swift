//
//  DriversJournalCell.swift
//  BizTrip
//
//  Created by Carl Henningsson on 12/30/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DriversJournalCell: UICollectionViewCell {
    
//    lazy var locations: UILabel = {
//        let l = UILabel()
//        l.textColor = SECONDARY_TEXT
//        l.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//
//        return l
//    }()
//
    lazy var timeStampLable: UILabel = {
        let tS = UILabel()
        tS.textColor = .white
        tS.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        tS.text = "July 10, 2018"

        return tS
    }()

    lazy var distanceLable: UILabel = {
        let dL = UILabel()
        dL.textColor = .white
        dL.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        dL.text = "450 km"

        return dL
    }()
    
    let mapView: MKMapView = {
        let mV = MKMapView()
        mV.mapType = .standard
        mV.layer.cornerRadius = 10
        
        return mV
    }()
    
    let mapShadow: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.shadowColor = SHADOW_COLOR
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        
        return view
    }()
    
    let routeTitle: UILabel = {
        let title = UILabel()
        title.text = "Name of Route"
        title.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        title.textAlignment = .left
        title.textColor = .white
        
        return title
    }()
    
    let deleteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "garbage"), for: .normal)
        btn.tintColor = MAIN_RED_COLOR
        btn.layer.shadowColor = SHADOW_COLOR
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowOpacity = 1
        
        return btn
    }()
    
    let tolls: UIImageView = {
        let toll = UIImageView()
        toll.image = #imageLiteral(resourceName: "money").withRenderingMode(.alwaysTemplate)
        toll.tintColor = MAIN_RED_COLOR
        toll.layer.shadowColor = SHADOW_COLOR
        toll.layer.shadowOffset = CGSize(width: 0, height: 2)
        toll.layer.shadowOpacity = 1
        
        return toll
    }()
    
    var startLatiutude: Double?
    var startLogitude: Double?
    var finishLatitude: Double?
    var finishLongitude: Double?
    
    var startLoc: CLLocationCoordinate2D?
    var finishLoc: CLLocationCoordinate2D?
    
    var currentRoute = 0
    
    var tripID: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc func deleteTrip() {
        if let userUid = UserDefaults.standard.object(forKey: "UID") {
        DataService.instance.REF_USER.child("\(userUid)").child("trips").child(tripID).removeValue()
        }
    }
    
    func configureCell(model: DrivesModel) {
        mapView.delegate = self
        
        deleteButton.addTarget(self, action: #selector(deleteTrip), for: .touchUpInside)
        
        tripID = model.TRIPID
        
        distanceLable.text = "\(model.DISTANCE) km"
        routeTitle.text = "\(model.TRIPTITEL)"

        let seconds = model.TIMESTAMP.doubleValue
        let timestampDate = NSDate(timeIntervalSince1970: seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"

        timeStampLable.text = dateFormatter.string(from: timestampDate as Date)
        
        addSubview(mapShadow)
        addSubview(mapView)
        addSubview(deleteButton)
        addSubview(tolls)
        addSubview(routeTitle)
        addSubview(timeStampLable)
        addSubview(distanceLable)
        
        if UIDevice.current.modelName == "iPhone X" {
            _ = mapShadow.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: frame.width * 0.05, widthConstant: frame.width * 0.85, heightConstant: frame.width * 1.3)
            _ = mapView.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: frame.width * 0.05, widthConstant: frame.width * 0.85, heightConstant: frame.width * 1.3)
        } else {
            _ = mapShadow.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: frame.width * 0.05, widthConstant: frame.width * 0.85, heightConstant: frame.width * 1.1)
            _ = mapView.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: frame.width * 0.05, widthConstant: frame.width * 0.85, heightConstant: frame.width * 1.1)
        }
        
        _ = deleteButton.anchor(mapView.topAnchor, left: mapView.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        _ = tolls.anchor(deleteButton.bottomAnchor, left: mapView.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        _ = routeTitle.anchor(mapView.bottomAnchor, left: mapView.leftAnchor, bottom: nil, right: nil, topConstant: frame.width * 0.05, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = timeStampLable.anchor(routeTitle.bottomAnchor, left: mapView.leftAnchor, bottom: nil, right: nil, topConstant: frame.width * 0.05, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = distanceLable.anchor(timeStampLable.bottomAnchor, left: mapView.leftAnchor, bottom: nil, right: nil, topConstant: frame.width * 0.05, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)

        placeOverlayOnMap(model: model)
    }
    
    func placeOverlayOnMap(model: DrivesModel) {
        let overlay = mapView.overlays
        let annotaions = mapView.annotations
        
        mapView.removeOverlays(overlay)
        mapView.removeAnnotations(annotaions)
        
        startLoc = CLLocationCoordinate2D(latitude: model.STARTLATITUDE, longitude: model.STARTLONGITUDE)
        finishLoc = CLLocationCoordinate2D(latitude: model.FINISHLATITUDE, longitude: model.FINISHLONGITUDE)
        
        let startPlace = MKPlacemark(coordinate: startLoc!)
        let finishPlace = MKPlacemark(coordinate: finishLoc!)
        
        let startItem = MKMapItem(placemark: startPlace)
        let finishItem = MKMapItem(placemark: finishPlace)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = startItem
        directionRequest.destination = finishItem
        directionRequest.transportType = .automobile
        directionRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else { return }
            
//            let routes = response.routes.count
            let route = response.routes[0]
//            var route = response.routes[self.currentRoute]

//            if self.currentRoute < routes - 1 {
//                route = response.routes[self.currentRoute]
//                self.currentRoute += 1
//            } else if self.currentRoute == routes - 1 {
//                route = response.routes[self.currentRoute]
//                self.currentRoute = 0
//            }

            if route.advisoryNotices.contains("Toll required.") {
                self.tolls.tintColor = MAIN_GREEN_COLOR
            }
            
//            if routes == 1 {
//                self.changeRouteButton.alpha = 0.8
//                self.changeRouteButton.isEnabled = false
//            } else {
//                self.changeRouteButton.alpha = 1.0
//                self.changeRouteButton.isEnabled = true
//            }
            
            self.mapView.add(route.polyline, level: .aboveRoads)
            self.setVisibleMapArea(polyline: route.polyline, edgeInsets: UIEdgeInsetsMake(35.0, 35.0, 35.0, 35.0), animated: true)
        }
        
        let startAnnotaion = MKPointAnnotation()
        let finishAnnotaion = MKPointAnnotation()
        
        startAnnotaion.coordinate = startLoc!
        finishAnnotaion.coordinate = finishLoc!
        
        startAnnotaion.title = "Start"
        finishAnnotaion.title = "Finish"
        
        mapView.addAnnotations([startAnnotaion, finishAnnotaion])
    }
    
    func setVisibleMapArea(polyline: MKPolyline, edgeInsets: UIEdgeInsets, animated: Bool) {
        mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgeInsets, animated: animated)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = MAIN_BLUE_COLOR
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DriversJournalCell: MKMapViewDelegate {
}
