//
//  StartViewController.swift
//  BizTrip
//
//  Created by Carl Henningsson on 12/28/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.layer.shadowColor = SHADOW_COLOR
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationController?.navigationBar.layer.shadowOpacity = 1
        
    }

}

