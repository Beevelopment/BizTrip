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
    let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    let blackView: UIView = {
        let bV = UIView()
        bV.backgroundColor = UIColor(white: 0, alpha: 0.5)
        bV.alpha = 0
        
        return bV
    }()
    
    let menus: [Menu] = {
        let privacy = Menu(titel: "Privacy Policy")
        let guide = Menu(titel: "Feedback")
        let share = Menu(titel: "Share BizTrip")
        let cancel = Menu(titel: "Cancel")
        
        var menuArray = [privacy, guide, share, cancel]
        
        return menuArray
    }()
    
    let topCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.sectionInset.top = 100
        
        let topCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        topCV.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
        return topCV
    }()
    
    var startViewController: StartViewController?
    
    func showMenu() {
        if let window = UIApplication.shared.keyWindow {
            
            let sViewWidth = window.frame.width / 2
            let windowHeight = window.frame.height
            
            window.addSubview(blurEffect)
            window.addSubview(topCollectionView)
            
            blurEffect.frame = window.bounds
            blurEffect.alpha = 0
            blurEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelDismiss)))
            
            topCollectionView.frame = CGRect(x: -sViewWidth, y: -50, width: sViewWidth, height: windowHeight + 50)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blurEffect.alpha = 0.7
                self.topCollectionView.frame = CGRect(x: 0, y: -50, width: sViewWidth, height: windowHeight + 50)
            }, completion: nil)
        }
    }
    
    @objc func test() {
        print("carl ca")
    }
    
    func privacyPressed() {
        handelDismiss()
        startViewController?.openTermsController()
    }
    
    func feedbackPressed() {
        handelDismiss()
        startViewController?.openFeedbackLauncher()
    }
    
    func sharePressed() {
        handelDismiss()
        startViewController?.shareApplication()
    }
    
    @objc func handelDismiss() {
        if let window = UIApplication.shared.keyWindow {
            let sViewWidth = window.frame.width / 3
            let windowHeight = window.frame.height
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blurEffect.alpha = 0
                self.topCollectionView.frame = CGRect(x: -sViewWidth, y: -50, width: sViewWidth, height: windowHeight + 50)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let menu = menus[indexPath.item]
        let cell = topCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        cell.menu = menu
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menu = menus[indexPath.item]
        
        if menu.titel == "Privacy Policy" {
            privacyPressed()
        } else if menu.titel == "Feedback" {
            feedbackPressed()
        } else if menu.titel == "Share BizTrip" {
            sharePressed()
        } else if menu.titel == "Cancel" {
            handelDismiss()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: topCollectionView.frame.width, height: 40)
    }
    
    override init() {
        super.init()
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topCollectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
    }
}
