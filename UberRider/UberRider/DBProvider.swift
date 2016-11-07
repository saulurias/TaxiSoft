//
//  DBProvider.swift
//  UberRider
//
//  Created by saul ulises urias guzmàn on 06/11/16.
//  Copyright © 2016 saul ulises urias guzmàn. All rights reserved.
//

import Foundation
import FirebaseDatabase


class DBProvider{
    
    private static let _instance = DBProvider()
    
    static var Instance: DBProvider {
        return _instance
    }
    
    var dbRef: FIRDatabaseReference{
        return FIRDatabase.database().reference()
    }
    
    var riderRef: FIRDatabaseReference{
        return dbRef.child(Constants.RIDERS)
    }
    
    // request reference
    var requestRef: FIRDatabaseReference {
        return dbRef.child(Constants.UBER_REQUEST)
    }
    
    // request accepted
    var requestAcceptedRef: FIRDatabaseReference{
        return dbRef.child(Constants.UBER_ACCEPTED)
    }
    
    func saveUser(withID: String, email: String, password: String){
        let data: Dictionary<String,Any> = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.isRider: true]
        
        riderRef.child(withID).child(Constants.DATA).setValue(data)

    }
    
    
}//Class
