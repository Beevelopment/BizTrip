//
//  TermsController.swift
//  BizTrip
//
//  Created by Carl Henningsson on 4/7/18.
//  Copyright © 2018 Henningsson Company. All rights reserved.
//

import UIKit

class TermsController: UIViewController {
    
    let dismissButton: UIButton = {
        let dismiss = UIButton(type: .system)
        dismiss.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        dismiss.tintColor = .white
        dismiss.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        
        return dismiss
    }()
    
    let titel: UILabel = {
        let t = UILabel()
        t.textAlignment = .left
        t.text = "Privacy Policy"
        t.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        t.textColor = .white
        
        return t
    }()
    
    let textView: UILabel = {
        let txtView = UILabel()
        txtView.text = "We are truly glad that you are using BizTrip as your drive journal. BizTrip uses Firebase as its backend service. All the necessary information that is needed for you to have the best possible experience is stored at the firebase database. Firebase is a property of Google and we act by Google’s privacy policy regarding the use of your information that is stored on firebase. To read more about the privacy policy go to:"
        txtView.textColor = .white
        txtView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        txtView.numberOfLines = 0
        
        return txtView
    }()
    
    let googlePrivacyPolicy: UIButton = {
        let fir = UIButton(type: .system)
        fir.setTitle("https://policies.google.com/privacy", for: .normal)
        fir.tintColor = MAIN_BLUE_COLOR
        fir.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        fir.titleLabel?.numberOfLines = 0
        fir.titleLabel?.textAlignment = .left
        fir.addTarget(self, action: #selector(openGoogleURL), for: .touchUpInside)
        
        return fir
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissController))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func openGoogleURL() {
        if UIApplication.shared.canOpenURL(URL(string: "https://policies.google.com/privacy")!) {
            guard let url = URL(string: "https://policies.google.com/privacy") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Carl: cant open url")
        }
    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupView() {
        view.setGradientColor(colorOne: greenTopColor, colorTwo: greenBottomColor)
        
        let sideMargin = view.frame.width / 10
        
        view.addSubview(dismissButton)
        view.addSubview(titel)
        view.addSubview(textView)
        view.addSubview(googlePrivacyPolicy)
        
        _ = dismissButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: sideMargin, leftConstant: 0, bottomConstant: 0, rightConstant: sideMargin, widthConstant: 30, heightConstant: 30)
        _ = titel.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: dismissButton.leftAnchor, topConstant: sideMargin, leftConstant: sideMargin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = textView.anchor(dismissButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: sideMargin, leftConstant: sideMargin, bottomConstant: 0, rightConstant: sideMargin, widthConstant: 0, heightConstant: 0)
        _ = googlePrivacyPolicy.anchor(textView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: sideMargin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
