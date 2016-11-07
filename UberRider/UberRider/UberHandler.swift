//
//  UberHandler.swift
//  UberRider
//
//  Created by saul ulises urias guzmàn on 06/11/16.
//  Copyright © 2016 saul ulises urias guzmàn. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol UberController: class {
    func canCallUber(delegateCalled: Bool)
}


class UberHandler {
    private static let _instance = UberHandler()
    
    weak var delegate: UberController?
    
    
    var rider = ""
    var driver = ""
    var rider_id = ""

    
    static var Instance: UberHandler {
        return _instance
    }
    
    func observeMessagesForRider(){
        //RIDER REQUESTED UBER
        DBProvider.Instance.requestRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.rider{
                        self.rider_id = snapshot.key
                        self.delegate?.canCallUber(delegateCalled: true)
                        print("The Value Is \(self.rider_id)")
                    }
                }
            }
        }
        
        //RIDER CANCELED UBER
        DBProvider.Instance.requestRef.observe(FIRDataEventType.childRemoved ) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.rider{
                        self.delegate?.canCallUber(delegateCalled: false)
                    }
                }
            }
        }
        
    }//observeMessagesForRider
    
    func requestUber(latitude: Double, longitude: Double){
        let data: Dictionary<String, Any> = [Constants.NAME: rider, Constants.LATITUDE: latitude, Constants.LONGITUDE: longitude]
        
        DBProvider.Instance.requestRef.childByAutoId().setValue(data)
        
        
        
    }// Request Uber
    
    func cancelUber(){
        DBProvider.Instance.requestRef.child(rider_id).removeValue()
    }// Cancel Uber
    
    
}// Class
