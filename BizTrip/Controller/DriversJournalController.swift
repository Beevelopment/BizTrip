//
//  DriversJournalController.swift
//  BizTrip
//
//  Created by Carl Henningsson on 12/30/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import MessageUI

class DriversJournalController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, MFMailComposeViewControllerDelegate {
    
    let cellID = "cellID"
    var drivesArray = [DrivesModel]()
    var distanceDriven = 0.0
    
    let routeTitle: UILabel = {
        let t = UILabel()
        t.text = "Routes"
        t.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        t.textAlignment = .left
        t.textColor = .white
        
        return t
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        
        return cv
    }()
    
    let totalDistancDriven: UILabel = {
        let tD = UILabel()
        tD.textColor = .white
        tD.textAlignment = .center
        tD.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        return tD
    }()
    
    let shareButton: UIButton = {
        let shareBtn = UIButton(type: .system)
        shareBtn.setImage(#imageLiteral(resourceName: "paper-plane"), for: .normal)
        shareBtn.tintColor = .white
        shareBtn.addTarget(self, action: #selector(shareJournal), for: .touchUpInside)
        
        return shareBtn
    }()
    
    let clearAllButton: UIButton = {
        let clear = UIButton(type: .system)
        clear.setTitle("Clear All", for: .normal)
        clear.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        clear.tintColor = .white
        clear.addTarget(self, action: #selector(clearAllButtonPressed), for: .touchUpInside)
        
        return clear
    }()
    
    let dismissButton: UIButton = {
        let dismiss = UIButton(type: .system)
        dismiss.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        dismiss.tintColor = .white
        dismiss.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        
        return dismiss
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientColor(colorOne: greenTopColor, colorTwo: greenBottomColor)
        
        collectionView.register(DriversJournalCell.self, forCellWithReuseIdentifier: cellID)
        
        downloadDataFromFirebase()
        setupView()
    }
    
    @objc private func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    func downloadDataFromFirebase() {
        activityIndicator.startAnimating()
        if let userUID = UserDefaults.standard.object(forKey: "UID") {
            DataService.instance.REF_USER.child("\(userUID)").child("trips").observe(.value, with: { (snapshot) in
                self.drivesArray = []
                self.distanceDriven = 0.0
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshot {
                        if let tripDict = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let info = DrivesModel(tripId: key, tripData: tripDict)
                            self.drivesArray.append(info)
                            
                            if let distanceFromFirebase = snap.childSnapshot(forPath: "distance").value as? Double {
                                self.distanceDriven = self.distanceDriven + distanceFromFirebase
                            }
                        }
                    }
                    
                    self.drivesArray.sort(by: { (drive1, drive2) -> Bool in
                        return drive1.TIMESTAMP.intValue > drive2.TIMESTAMP.intValue
                    })
                    
                }
                activityIndicator.stopAnimating()
                
                if self.drivesArray.count < 1 {
                    emptyArrayMessage.isHidden = false
                } else {
                    let roundedDistance = String(format: "%.1f", self.distanceDriven)
                    emptyArrayMessage.isHidden = true
                    self.collectionView.reloadData()
                    self.totalDistancDriven.text = "Total distance: \(roundedDistance) km"
                }
            }, withCancel: nil)
        }
    }
    
    @objc private func clearAllDataFromFirebase() {
        if let uid = userUid {
            let firebaseRef = DataService.instance.REF_USER.child("\(uid)").child("trips")
            firebaseRef.removeValue()
            self.drivesArray = []
            self.collectionView.reloadData()
            self.totalDistancDriven.text = ""
        }
    }
    
    @objc private func clearAllButtonPressed() {
        let alert = UIAlertController(title: "Clear All", message: "Are you sure you want to clear your drive journal?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { action in
            self.clearAllDataFromFirebase()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drivesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let drive = drivesArray[indexPath.item]
        
        if let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? DriversJournalCell {
            cell.configureCell(model: drive)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.8, height: collectionView.frame.height)
    }
    
    private func shareEmail() {
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            let subject = "BizTrip LogBook"
            let totalDistance = totalDistancDriven.text!
            let logoImage: NSData = UIImagePNGRepresentation(UIImage(named: "logo")!)! as NSData
            
            let fileName = "LogBook.csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            var csvText = "Title,Date,Start Location,End Location,Distance (km)\n"
            
            for trip in drivesArray {
                let title = trip.TRIPTITEL
                
                let timeStamp = trip.TIMESTAMP.doubleValue
                let timeStampDate = NSDate(timeIntervalSince1970: timeStamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let date = dateFormatter.string(from: timeStampDate as Date)
                
                print("Carl: \(date)")
                
                let start = trip.STARTADRESS
                let end = trip.FINISHADRESS
                let distance = trip.DISTANCE
                
                let newLine = "\(title),\(date),\(start),\(end),\(distance)\n"
                csvText.append(contentsOf: newLine)
            }
            
            csvText.append(contentsOf: "\n\(totalDistance)")
            
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("Carl: Error")
            }

            mail.setSubject(subject)
            mail.setMessageBody("Your LogBook from BizTrip has been sent as a .csv file. See attached.\n\nBest Regards BizTrip", isHTML: true)
            mail.addAttachmentData(NSData(contentsOf: path!)! as Data, mimeType: "text/csv", fileName: "LogBook.csv")
            mail.addAttachmentData(logoImage as Data, mimeType: "image/png", fileName: "imageName")

            present(mail, animated: true, completion: nil)
        } else {
            let noEmailAlert = UIAlertController(title: "No Email", message: "You have no verified email connected, do you want to add one?", preferredStyle: .alert)
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            let yesAction = UIAlertAction(title: "Go to Setting", style: .default) { action in
                guard let settingURL = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingURL) {
                    UIApplication.shared.open(settingURL, completionHandler: { (sucess) in
                        print("Carl: setting opened sucessfully")
                    })
                }
            }
            
            noEmailAlert.addAction(noAction)
            noEmailAlert.addAction(yesAction)
            
            present(noEmailAlert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    private func shareOther() {
        let fileName = "LogBook.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Title,Date,Start Location,End Location,Distance (km)\n"
        
        let subject = "BizTrip LogBook"
        let totalDistance = totalDistancDriven.text!
        let logoImage = UIImage(named: "logo")
        var share = [AnyObject]()

        share.append(subject as AnyObject)

        for trip in drivesArray {
            let title = trip.TRIPTITEL
            
            let timeStamp = trip.TIMESTAMP.doubleValue
            let timeStampDate = NSDate(timeIntervalSince1970: timeStamp)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date = dateFormatter.string(from: timeStampDate as Date)
            
            let start = trip.STARTADRESS
            let end = trip.FINISHADRESS
            let distance = trip.DISTANCE
            
            let newLine = "\(title),\(date),\(start),\(end),\(distance)\n"
            csvText.append(contentsOf: newLine)
        }
        
        csvText.append(contentsOf: "\n\(totalDistance)")
        
        share.append(logoImage!)
        share.append(path! as AnyObject)

        let activityController = UIActivityViewController(activityItems: share, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view

        self.present(activityController, animated: true, completion: nil)
    }
    
    @objc private func shareJournal() {
        if drivesArray.count > 0 {
            let actionSheet = UIAlertController(title: "Share Journal", message: "How would you like to share your drive journal?", preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let email = UIAlertAction(title: "E-mail", style: .default) { action in
                self.shareEmail()
            }
            let other = UIAlertAction(title: "Other", style: .default) { action in
                self.shareOther()
            }
        
            actionSheet.addAction(cancel)
            actionSheet.addAction(email)
            actionSheet.addAction(other)

            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        let containerHeight = view.frame.height / 8
        let sideMargin = view.frame.width / 10
        
        view.addSubview(routeTitle)
        view.addSubview(shareButton)
        view.addSubview(dismissButton)
        view.addSubview(collectionView)
        view.addSubview(totalDistancDriven)
        view.addSubview(clearAllButton)
        view.addSubview(activityIndicator)
        view.addSubview(emptyArrayMessage)
        
        _ = routeTitle.anchor(nil, left: view.leftAnchor, bottom: collectionView.topAnchor, right: nil, topConstant: 0, leftConstant: sideMargin, bottomConstant: view.frame.width * 0.05, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = shareButton.anchor(nil, left: nil, bottom: routeTitle.bottomAnchor, right: dismissButton.leftAnchor, topConstant: 0, leftConstant: -8, bottomConstant: 10, rightConstant: sideMargin, widthConstant: 30, heightConstant: 30)
        _ = dismissButton.anchor(nil, left: nil, bottom: routeTitle.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: sideMargin, widthConstant: 30, heightConstant: 30)
        _ = collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: view.frame.height * 0.18, leftConstant: 0, bottomConstant: containerHeight, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = totalDistancDriven.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: sideMargin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = clearAllButton.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: sideMargin / 2, bottomConstant: sideMargin, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = activityIndicator.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = emptyArrayMessage.anchor(collectionView.topAnchor, left: collectionView.leftAnchor, bottom: collectionView.bottomAnchor, right: collectionView.rightAnchor, topConstant: 0, leftConstant: sideMargin, bottomConstant: 0, rightConstant: sideMargin, widthConstant: 0, heightConstant: 0)
    }
}
