//
//  UberHandler.swift
//  UberDriver
//
//  Created by saul ulises urias guzmàn on 06/11/16.
//  Copyright © 2016 saul ulises urias guzmàn. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol UberController: class {
    func acceptUber(lat: Double, long: Double);
}

class UberHandler {
    private static let _instance = UberHandler()
    
    //Weak se utiliza para indicar que esta variable no sera instanciada mientras no la necesitemos
    weak var delegate: UberController?
    
    var rider = ""
    var driver = ""
    var driver_id = ""
    
    
    static var Instance: UberHandler {
        return _instance
    }
    
    func observeMessageForDridver(){
        //  RIDER REQUESTED AN UBER
        DBProvider.Instance.requestRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let latitude = data[Constants.LATITUDE] as? Double {
                    if let longitude = data[Constants.LONGITUDE] as? Double {
                        //Inform the driver VC the Request
                        self.delegate?.acceptUber(lat: latitude, long: longitude)
                    }
                }
            }
            
        }
        
        
        //observeMessageForDriver
    }
    
    
}











