//
//  TitleLauncher.swift
//  BizTrip
//
//  Created by Carl Henningsson on 8/2/18.
//  Copyright © 2018 Henningsson Company. All rights reserved.
//

import Foundation
import UIKit

class TitleLauncher: NSObject, UITextViewDelegate {
    
    var startViewController: StartViewController?
    let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = SHADOW_COLOR
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 10
        view.alpha = 0
        
        return view
    }()
    
    let button: UIButton = {
       let btn = UIButton(type: .system)
        btn.setTitle("Save", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        btn.alpha = 0
        
        return btn
    }()
    
    let buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = SHADOW_COLOR
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.cornerRadius = 25
        view.alpha = 0
        
        return view
    }()
    
    let desc: UILabel = {
        let desc = UILabel()
        desc.text = "Enter a describing title for this trip to save it."
        desc.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        desc.textAlignment = .center
        desc.textColor = HINT_TEXT
        desc.alpha = 0
        desc.numberOfLines = 0
        
        return desc
    }()
    
    lazy var setTitle: UITextView = {
        let text = UITextView()
        text.text = "Enter describing title..."
        text.textColor = DIVIDERS
        text.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        text.layer.borderColor = DIVIDERS.cgColor
        text.layer.borderWidth = 1
        text.layer.cornerRadius = 20
        text.textContainerInset.top = 12
        text.textContainerInset.left = 10
        text.textContainerInset.right = 10
        text.delegate = self
        text.alpha = 0
        
        return text
    }()
    
    let characterCount: UILabel = {
        let count = UILabel()
        count.text = "0/15"
        count.textColor = DIVIDERS
        count.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        count.alpha = 0
        
        return count
    }()
    
    func showTitle() {
        if let window = UIApplication.shared.keyWindow {
            
            if smalliPhone.contains(UIDevice.current.modelName) {
                desc.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            }
            
            button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
            
            let containerW = window.frame.width * 0.8
            let fourty = window.frame.width * 0.4
            
            window.addSubview(blurEffect)
            window.addSubview(container)
            window.addSubview(desc)
            window.addSubview(setTitle)
            window.addSubview(characterCount)
            window.addSubview(buttonView)
            window.addSubview(button)
            
            blurEffect.frame = window.bounds
            blurEffect.alpha = 0
            
            container.frame = CGRect(x: window.frame.midX - fourty, y: window.frame.midY - fourty, width: containerW, height: containerW * 0.66)
            _ = desc.anchor(container.topAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
            _ = setTitle.anchor(desc.bottomAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 40)
            _ = characterCount.anchor(setTitle.bottomAnchor, left: nil, bottom: nil, right: setTitle.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
            buttonView.frame = CGRect(x: window.frame.midX - containerW * 0.33, y: window.frame.midY + fourty * 0.33 - 25, width: containerW * 0.66, height: 50)
            button.frame = CGRect(x: window.frame.midX - buttonView.frame.width / 2, y: window.frame.midY + fourty * 0.33 - 25, width: containerW * 0.66, height: 50)
            
            button.setGradientColor(colorOne: greenTopColor, colorTwo: greenBottomColor)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blurEffect.alpha = 0.7
                self.container.alpha = 1
                self.desc.alpha = 1
                self.setTitle.alpha = 1
                self.characterCount.alpha = 1
                self.buttonView.alpha = 1
                self.button.alpha = 1
            }, completion: nil)
        }
    }
    
    @objc func handelDismiss() {
        if let window = UIApplication.shared.keyWindow {
            window.endEditing(true)
            
            UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blurEffect.alpha = 0
                self.container.alpha = 0
                self.desc.alpha = 0
                self.setTitle.alpha = 0
                self.characterCount.alpha = 0
                self.buttonView.alpha = 0
                self.button.alpha = 0
            }, completion: nil)
        }
    }
    
    @objc func saveButtonPressed() {
        if setTitle.text != "Enter describing title..." {
            handelDismiss()
            startViewController?.saveTripToFirebase(tripTitle: setTitle.text)
            setTitle.text = "Enter describing title..."
            setTitle.textColor = HINT_TEXT
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = setTitle.text.count
        
        if count < 16 {
            characterCount.text = "\(count)/15"
        } else {
            setTitle.text.removeLast()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if setTitle.text.isEmpty || setTitle.text == "Enter describing title..." {
            setTitle.text = ""
            setTitle.textColor = SECONDARY_TEXT
        }
    }
}
