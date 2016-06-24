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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //若user已經登入過後，只要回到這個頁面，便會自動跳轉到loggedIn頁面
        if NSUserDefaults.standardUserDefaults().objectForKey(KEY_UID) != nil{
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
        
    }
    
    
    
    
    
    
    //Email Logged IN
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    @IBAction func attemptEmailLoggedIn(sender: UIButton) {
        
        if let mail = emailTextField.text where mail != "", let password = passwordTextField.text where password != "" {
            DataService.ds.REF_BASE.authUser(mail, password: password, withCompletionBlock: { (error, authData) in
                if error != nil{
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST{
                        DataService.ds.REF_BASE.createUser(mail, password: password, withValueCompletionBlock: { (error, result ) in
                            if error != nil{
                                self.showAlertMessage(ALERT_TITLE_OOPS, message: "Problem creating account\(error)")
                            }else{
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                DataService.ds.REF_BASE.authUser(mail, password: password, withCompletionBlock: nil)
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            }
                        })
                        
                    }
                    if error.code == STATUS_PASSWORD_WRONG{
                        self.showAlertMessage(ALERT_TITLE_OOPS, message: "Your password is wrong!!")
                    }

                }else{
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
            
            
        }else{
            self.showAlertMessage("Email and Password are required!!", message: "You must input ur email and password!!")
        }
    }
    
    
    
    
    
    

    
    
    
    
    // MARK: FaceBook LoggedIn
    
    @IBAction func fbBtnPressed(sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, error: NSError!) in
            
            if error != nil{
                self.showAlertMessage(ALERT_TITLE_OOPS, message: "Facebook login failed. Error: \(error)")
            }else{
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    if error != nil{
                        self.showAlertMessage(ALERT_TITLE_OOPS, message: "Login Failed \(error)")
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

    
    
    
    // MARK: Helper
    
    func showAlertMessage(title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: ALERT_TITLE_OKAY, style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func FBShowAlert(title: String!, message: String!){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: ALERT_TITLE_OKAY, style: .Default) { (UIAlertAction) in
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
        
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    func checkFieldTextIsEmpty() -> Bool{
        if (((emailTextField.text?.isEmpty)!) || ((passwordTextField.text?.isEmpty)!)){
            self.showAlertMessage(ALERT_TITLE_OOPS, message: "Please check the textField!!")
            return true
        }else{
            return false
        }
    }
}
