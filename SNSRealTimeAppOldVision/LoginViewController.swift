//
//  LoginViewController.swift
//  SNSRealTimeApp
//
//  Created by 辛忠翰 on 2016/6/22.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    //var firebase = Firebase(url: "https://snsrealtimeapp-16145.firebaseio.com/")
    var firebase = FIRDatabase.database().reference()
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func logInBtn(sender: UIButton) {
        self.logInUser()
    }
    
    @IBAction func signUpBtn(sender: UIButton) {
        /* old Firebase version of creatUser
        firebase.createUser(emailTextField.text, password: passwordTextField.text) { (error: NSError!) -> Void in
            if error != nil{
                self.showAlertMessage("OOps!!",message: error.localizedDescription)
                print(error.localizedDescription)
            }else{
                print("New user created!!")
                self.logInUser()
            }
        }
        */
        
        //new Firebase version of firebase.createUser
        FIRAuth.auth()?.createUserWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: { (user: FIRUser?, error: NSError?) in
            if error != nil{
                self.showAlertMessage("OOps!!",message: error!.localizedDescription)
                print(error!.localizedDescription)
            }else{
                print("New user created!!")
                self.logInUser()
            }
        })
        
        
        
        
    }
    
    func logInUser(){
        print("User logged in~~")
        /* old Firebase version of authUser
        firebase.authUser(emailTextField.text, password: passwordTextField.text) { (error: NSError!, authData: FAuthData!) in
            if error != nil{
                self.showAlertMessage("OOps!!",message: error.localizedDescription)
                print(error.localizedDescription)
            }else{
                
                self.showAlertMessage("Good!!",message: "Logged in \(authData)")
                print("Logged in \(authData)")
            }
        }
        */
        
        FIRAuth.auth()?.signInWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: { (user: FIRUser?, error: NSError?) in
            if error != nil{
                self.showAlertMessage("OOps!!",message: error!.localizedDescription)
                print(error!.localizedDescription)
            }else{
                //old version's authData -> user
                self.showAlertMessage("Good!!",message: "Logged in \(user)")
                print("Logged in \(user)")
            }

        })
 
    }

    
    
    // MARK: Helper
    
    func showAlertMessage(title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
