//
//  LoginViewController.swift
//  SNSRealTimeApp
//
//  Created by 辛忠翰 on 2016/6/22.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    var firebase = Firebase(url: "https://realtimeappoldvision.firebaseio.com")
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func logInBtn(sender: UIButton) {
        self.logInUser()
    }
    
    @IBAction func signUpBtn(sender: UIButton) {
        if !checkFieldTextIsEmpty(){
        //old Firebase version of creatUser
        firebase.createUser(emailTextField.text, password: passwordTextField.text) { (error: NSError!) -> Void in
            if error != nil{
                self.showAlertMessage("OOps!!",message: error.localizedDescription)
                print(error.localizedDescription)
            }else{
                print("New user created!!")
                self.logInUser()
            }
        }
      
        }
    }
    
    func logInUser(){
        if !checkFieldTextIsEmpty(){
        print("User logged in~~")
        //old Firebase version of authUser
        firebase.authUser(emailTextField.text, password: passwordTextField.text) { (error: NSError!, authData: FAuthData!) in
            if error != nil{
                self.showAlertMessage("OOps!!",message: error.localizedDescription)
                print(error.localizedDescription)
            }else{
                
                self.showAlertMessage("Good!!",message: "Logged in \(authData)")
                print("Logged in \(authData)")
            }
        }
        
        }
        
    }

    
    
    // MARK: Helper
    
    func showAlertMessage(title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func FBShowAlert(title: String!, message: String!){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Okay", style: .Default) { (UIAlertAction) in
            self.performSegueWithIdentifier("loggedIn", sender: nil)
        }
        
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    func checkFieldTextIsEmpty() -> Bool{
        if (((emailTextField.text?.isEmpty)!) || ((passwordTextField.text?.isEmpty)!)){
            self.showAlertMessage("OOps", message: "Please check the textField!!")
            return true
        }else{
            return false
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: FaceBook
    
    @IBAction func fbBtnPressed(sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, error: NSError!) in
            
            if error != nil{
                self.showAlertMessage("OOps", message: "Facebook login failed. Error: \(error)")
            }else{
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    if error != nil{
                        self.showAlertMessage("OOps", message: "Login Failed \(error)")
                    }else{
                        //出現alert視窗後，似乎就無法執行performSegueWithIdentifier
                        
                        //所以把self.performSegueWithIdentifier("loggedIn", sender: nil)寫到okAction的handler中
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.FBShowAlert("Successful", message: "Login FB \(authData)")
                       
                    }
                })
            }
        }
    }

}
