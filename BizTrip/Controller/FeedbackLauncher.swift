//
//  FeedbackLauncher.swift
//  BizTrip
//
//  Created by Carl Henningsson on 5/10/18.
//  Copyright © 2018 Henningsson Company. All rights reserved.
//

import UIKit

class FeedbackLauncher: NSObject, UITextViewDelegate {
    
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
    
    lazy var setTitle: UITextView = {
        let text = UITextView()
        text.text = "Enter feedback..."
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
    
    func showFeedback() {
        if let window = UIApplication.shared.keyWindow {
            
            button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
            
            let containerW = window.frame.width * 0.8
            let fourty = window.frame.width * 0.4
            
            window.addSubview(blurEffect)
            window.addSubview(container)
            window.addSubview(setTitle)
            window.addSubview(buttonView)
            window.addSubview(button)
            
            blurEffect.frame = window.bounds
            blurEffect.alpha = 0
            blurEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelDismiss)))
            
            container.frame = CGRect(x: window.frame.midX - fourty, y: window.frame.midY - fourty, width: containerW, height: containerW * 0.66)
            _ = setTitle.anchor(container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: button.frame.height / 2 + 40, rightConstant: 20, widthConstant: 0, heightConstant: 40)
            buttonView.frame = CGRect(x: window.frame.midX - containerW * 0.33, y: window.frame.midY + fourty * 0.33 - 25, width: containerW * 0.66, height: 50)
            button.frame = CGRect(x: window.frame.midX - buttonView.frame.width / 2, y: window.frame.midY + fourty * 0.33 - 25, width: containerW * 0.66, height: 50)
            
            button.setGradientColor(colorOne: greenTopColor, colorTwo: greenBottomColor)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blurEffect.alpha = 0.7
                self.container.alpha = 1
                self.setTitle.alpha = 1
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
                self.setTitle.alpha = 0
                self.buttonView.alpha = 0
                self.button.alpha = 0
            }, completion: nil)
        }
    }
    
    @objc func saveButtonPressed() {
        if setTitle.text != "Enter feedback..." || !setTitle.text.isEmpty {
            let feedbackDict: Dictionary = ["feedback": setTitle.text]
            DataService.instance.REF_FEEDBACK.childByAutoId().updateChildValues(feedbackDict as [AnyHashable : Any])
            handelDismiss()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if setTitle.text == "Enter feedback..." {
            setTitle.text = ""
            setTitle.textColor = SECONDARY_TEXT
        }
    }
}

















