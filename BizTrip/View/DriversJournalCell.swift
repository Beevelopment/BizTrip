//
//  DriversJournalCell.swift
//  BizTrip
//
//  Created by Carl Henningsson on 12/30/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import Foundation
import UIKit

class DriversJournalCell: UITableViewCell {
    
    let timeStampLable: UILabel = {
        let tS = UILabel()
        tS.text = "HH:MM:SS"
        tS.textColor = SECONDARY_TEXT
        tS.font = UIFont(name: GILL_SANS, size: 16)!
        
        return tS
    }()
    
    let distanceLable: UILabel = {
        let dL = UILabel()
        dL.text = "450 km"
        dL.textColor = SECONDARY_TEXT
        dL.font = UIFont(name: GILL_SANS, size: 16)!
        
        return dL
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .blue
        
        addSubview(timeStampLable)
        addSubview(distanceLable)
        
        _ = timeStampLable.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = distanceLable.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}














