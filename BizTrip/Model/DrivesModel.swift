//
//  DrivesModel.swift
//  BizTrip
//
//  Created by Carl Henningsson on 12/30/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DrivesModel {
    
    private var _DISTANCE: Double!
    private var _TIMESTAMP: NSNumber!
    private var _STARTLATITUDE: Double!
    private var _STARTLONGITUDE : Double!
    private var _FINISHLATITUDE: Double!
    private var _FINISHLONGITUDE: Double!
    private var _STARTADRESS: String!
    private var _FINISHADRESS: String!
    private var _TRIPTITEL: String!
    private var _TRIPID: String!
    
    var DISTANCE: Double {
        return _DISTANCE
    }
    var TIMESTAMP: NSNumber {
        return _TIMESTAMP
    }
    var STARTLATITUDE: Double {
        return _STARTLATITUDE
    }
    var STARTLONGITUDE: Double {
        return _STARTLONGITUDE
    }
    var FINISHLATITUDE: Double {
        return _FINISHLATITUDE
    }
    var FINISHLONGITUDE: Double {
        return _FINISHLONGITUDE
    }
    var STARTADRESS: String {
        return _STARTADRESS
    }
    var FINISHADRESS: String {
        return _FINISHADRESS
    }
    var TRIPTITEL: String {
        return _TRIPTITEL
    }
    var TRIPID: String {
        return _TRIPID
    }
    
    init(distance: Double, timastamp: NSNumber, startLatitude: Double, startLongitude: Double, finishLatitude: Double, finishLongitude: Double, startAdress: String, finishAdress: String, tripTitel: String) {
        self._DISTANCE = distance
        self._TIMESTAMP = timastamp
        self._STARTLATITUDE = startLatitude
        self._STARTLONGITUDE = startLongitude
        self._FINISHLATITUDE = finishLatitude
        self._FINISHLONGITUDE = finishLongitude
        self._STARTADRESS = startAdress
        self._FINISHADRESS = finishAdress
        self._TRIPTITEL = tripTitel
    }
    
    init(tripId: String, tripData: Dictionary<String, AnyObject>) {
        self._TRIPID = tripId
        
        if let DISTANCE = tripData["distance"] as? Double {
            self._DISTANCE = DISTANCE
        }
        if let TIMESTAMP = tripData["timeStamp"] as? NSNumber {
            self._TIMESTAMP = TIMESTAMP
        }
        if let STARTLATITUDE = tripData["startLatitude"] as? Double {
            self._STARTLATITUDE = STARTLATITUDE
        }
        if let STARTLONGITUDE = tripData["startLongitude"] as? Double {
            self._STARTLONGITUDE = STARTLONGITUDE
        }
        if let FINISHLATITUDE = tripData["finishLatitude"] as? Double {
            self._FINISHLATITUDE = FINISHLATITUDE
        }
        if let FINISHLONGITUDE = tripData["finishLongitude"] as? Double {
            self._FINISHLONGITUDE = FINISHLONGITUDE
        }
        if let STARTADRESS = tripData["startAdress"] as? String {
            self._STARTADRESS = STARTADRESS
        }
        if let FINISHADRESS = tripData["finishAdress"] as? String {
            self._FINISHADRESS = FINISHADRESS
        }
        if let TRIPTITEL = tripData["titel"] as? String {
            self._TRIPTITEL = TRIPTITEL
        }
    }
}
