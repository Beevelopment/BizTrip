//
//  UpdateController.swift
//  BizTrip
//
//  Created by Carl Henningsson on 4/25/18.
//  Copyright © 2018 Henningsson Company. All rights reserved.
//

import UIKit

class UpdateController: UIViewController {
    
    let logoImage: UIImageView = {
        let logoImg = UIImageView(image: #imageLiteral(resourceName: "logo"))
        logoImg.contentMode = .scaleAspectFit
        
        return logoImg
    }()
    
    let text: UILabel = {
        let txt = UILabel()
        txt.textAlignment = .left
        txt.text = "There is a new version of BizTrip avaible. Go to App Store and update."
        txt.numberOfLines = 0
        txt.textColor = MAIN_GREEN_COLOR
        txt.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        
        return txt
    }()
    
    let button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Go to App Store", for: .normal)
        btn.tintColor = MAIN_BLUE_COLOR
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.addTarget(self, action: #selector(openAppStore), for: .touchUpInside)
        
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let heightMargin = view.frame.height / 10
        let sideMargin = view.frame.width / 10
        
        view.addSubview(logoImage)
        view.addSubview(text)
        view.addSubview(button)
        
        _ = logoImage.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: sideMargin, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width / 2.5, heightConstant: 0)
        _ = text.anchor(logoImage.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: -heightMargin / 3, leftConstant: sideMargin, bottomConstant: 0, rightConstant: sideMargin, widthConstant: 0, heightConstant: 0)
        _ = button.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: sideMargin, bottomConstant: heightMargin, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    @objc private func openAppStore() {
        if UIApplication.shared.canOpenURL(URL(string: "https://itunes.apple.com/us/app/hootch-make-it-from-home/id1317524355?mt=8")!) {
            guard let url = URL(string: "https://itunes.apple.com/us/app/hootch-make-it-from-home/id1317524355?mt=8") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Carl: cant open url")
        }
    }
}

















