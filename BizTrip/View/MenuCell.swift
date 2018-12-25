//
//  TopMenuCell.swift
//  BizTrip
//
//  Created by Carl Henningsson on 4/26/18.
//  Copyright © 2018 Henningsson Company. All rights reserved.
//

import UIKit

class TopMenuCell: UICollectionViewCell {
    var menu: Menu? {
        didSet {
            titel.text = menu?.titel
        }
    }
    
    let titel: UILabel = {
        let t = UILabel()
        t.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        t.textColor = .white
        t.textAlignment = .left
        
        return t
    }()
    
    private func setupCV() {
        addSubview(titel)
        
        _ = titel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCV()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
