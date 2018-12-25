//
//  MenuLauncher.swift
//  BizTrip
//
//  Created by Carl Henningsson on 4/7/18.
//  Copyright © 2018 Henningsson Company. All rights reserved.
//

import UIKit

class MenuLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    let blackView: UIView = {
        let bV = UIView()
        bV.backgroundColor = UIColor(white: 0, alpha: 0.5)
        bV.alpha = 0
        
        return bV
    }()
    
    let settingsView: UIView = {
        let sV = UIView()
        sV.backgroundColor = MAIN_GREEN_COLOR
        
        return sV
    }()
    
//    let applicationGuide: UIButton = {
//        let guide = UIButton(type: .system)
//        guide.setTitle("App Guide", for: .normal)
//        guide.tintColor = .white
//        guide.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//
//        return guide
//    }()
    
//    let privacyPolicy: UIButton = {
//        let privacy = UIButton(type: .system)
//        privacy.setTitle("Privacy Policy", for: .normal)
//        privacy.tintColor = .white
//        privacy.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//
//        return privacy
//    }()
//
//    let dismissMenu: UIButton = {
//        let disMenu = UIButton(type: .system)
//        disMenu.setTitle("Cancel", for: .normal)
//        disMenu.tintColor = .white
//        disMenu.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//
//        return disMenu
//    }()
    
    let topCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let topCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        topCV.backgroundColor = MAIN_GREEN_COLOR
        
        return topCV
    }()
    
    let bottomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let bottomCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        bottomCV.backgroundColor = MAIN_GREEN_COLOR
        
        return bottomCV
    }()
    
    var startViewController: StartViewController?
    
    func showMenu() {
        if let window = UIApplication.shared.keyWindow {
            let sViewWidth = window.frame.width / 2
            let windowHeight = window.frame.height
            
            window.addSubview(blackView)
            window.addSubview(settingsView)
            window.addSubview(topCollectionView)
            window.addSubview(bottomCollectionView)
            
            _ = blackView.anchor(window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            topCollectionView.frame = CGRect(x: -sViewWidth, y: 0, width: sViewWidth, height: windowHeight / 2)
            bottomCollectionView.frame = CGRect(x: -sViewWidth, y: windowHeight / 2, width: sViewWidth, height: windowHeight / 2)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelDismiss)))
//            applicationGuide.addTarget(self, action: #selector(guidePressed), for: .touchUpInside)
//            privacyPolicy.addTarget(self, action: #selector(privacyPressed), for: .touchUpInside)
//            dismissMenu.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.topCollectionView.frame = CGRect(x: 0, y: 0, width: sViewWidth, height: windowHeight / 2)
                self.bottomCollectionView.frame = CGRect(x: 0, y: windowHeight / 2, width: sViewWidth, height: windowHeight / 2)
            }, completion: nil)
        }
    }
    
    @objc func guidePressed() {
    }
    
    @objc func privacyPressed() {
        handelDismiss()
        startViewController?.openTermsController()
    }
    
    @objc func cancelPressed() {
        handelDismiss()
    }
    
    @objc func handelDismiss() {
        if let window = UIApplication.shared.keyWindow {
            let sViewWidth = window.frame.width / 3
            let windowHeight = window.frame.height
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0
                self.settingsView.frame = CGRect(x: -sViewWidth, y: 0, width: sViewWidth, height: windowHeight)
                self.topCollectionView.frame = CGRect(x: -sViewWidth, y: 0, width: sViewWidth, height: windowHeight / 2)
                self.bottomCollectionView.frame = CGRect(x: -sViewWidth, y: windowHeight / 2, width: sViewWidth, height: windowHeight / 2)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: topCollectionView.frame.width, height: 40)
    }
    
    override init() {
        super.init()
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
}
