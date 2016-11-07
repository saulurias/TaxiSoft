//
//  SigInVC.swift
//  UberDriver
//
//  Created by saul ulises urias guzmàn on 04/11/16.
//  Copyright © 2016 saul ulises urias guzmàn. All rights reserved.
//

import UIKit
import FirebaseAuth


class SigInVC: UIViewController {
    
    private let DRIVER_SEGUE = "DriverVC"

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logIn(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                if message != nil{
                    self.alertTheUser(title: "Problem With Authentication", message: message!)
                }else{
                    self.performSegue(withIdentifier: self.DRIVER_SEGUE, sender: nil)
                    print("Login Completed")
                    
                }
            })
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password")
        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Creating A New User", message: message!)
                } else{
                    self.performSegue(withIdentifier: self.DRIVER_SEGUE, sender: nil)
                    print("Created User Completed")
                    
                }
                
            })
        }else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password")
        }
    }

    private func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert,animated: true, completion: nil)
    }
   

}//Class
