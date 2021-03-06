//
//  AuthProvider.swift
//  UberRider
//
//  Created by saul ulises urias guzmàn on 04/11/16.
//  Copyright © 2016 saul ulises urias guzmàn. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ msg: String?) -> Void

struct LoginErrorCode {
    static let INVALID_EMAIL = "Invalid Email Adress, Please Provide A Real Email Adress"
    static let WRONG_PASSWORD = "Wrong Password, Please Enter The Correct Password"
    static let PROBLEM_CONNECTING = "Problem Connecting To Database, Please Try Later"
    static let USER_NOT_FOUND = "User Not Found, Please Register"
    static let EMAIL_ALREADY_IN_USE = "Email Already In User, Please Use Another Email"
    static let WEAK_PASSWORD = "Password Should Be At Least 6 Characters Long"
}

class AuthProvider {
    private static let _instance = AuthProvider();
    
    static var Instance: AuthProvider {
        return _instance
    }
    
    
    func login(withEmail: String, password: String, loginHandler: LoginHandler?){
        
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            }else{
                loginHandler?(nil);
            }
            
            
        })
    }//Login Func
    
    func logOut() -> Bool{
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                return true
            } catch {
                return false
            }
        }
        
        return true
    }//Logout Func
    
    
    func signUp(withEmail:String, password:String, loginHandler:LoginHandler?){
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError , loginHandler: loginHandler)
            } else{
                
                if user?.uid != nil {
                    //Store user to database
                    DBProvider.Instance.saveUser(withID: user!.uid, email: withEmail, password: password)
                    
                    //login the user
                    self.login(withEmail: withEmail, password: password, loginHandler: loginHandler)
                }
                
            }
            
        })
    }//signUp function
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?){
        if let errCode = FIRAuthErrorCode(rawValue: err.code){
            switch errCode {
            case .errorCodeWrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)
                break
                
            case .errorCodeInvalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break
                
            case .errorCodeUserNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                break
                
            case .errorCodeEmailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
                break
                
            case .errorCodeWeakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)
                break
                
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING)
                print("Error Encontrado: \(errCode.rawValue.description)")
                break
            }
        }
    } //handlErrors Func
    
    
    
    
}//Class

