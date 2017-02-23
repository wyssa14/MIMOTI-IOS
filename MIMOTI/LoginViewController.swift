//
//  LoginViewController.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 04/04/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import UIKit
import Locksmith

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginActivity: UIActivityIndicatorView!
    
    
    // Get the shared UserDefaults object
    let defaults = UserDefaults.standard

    // allocate helper variable
    var loginSucessful : Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // hide activity indicator
        loginActivity.isHidden = true
        
    }
    
    
    // dismiss textfield when user presses the return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // return on 'done' - dismiss keyboard
        textField.resignFirstResponder();
        return true;
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(true, moveValue: 50)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(false, moveValue: 50)
    }
    
    // helper function. sliding the textfields when keyboard appears
    func animateViewMoving (_ up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    
    
    @IBAction func additionalSettingsTapped(_ sender: Any) {
        
            let alert = UIAlertController(title: "MIDATA Zieladresse", message: "Produktiv: https://ch.midata.coop \n Test: https://test.midata.coop", preferredStyle: .alert)
            
                alert.addTextField { (textField) in
                textField.text = self.defaults.value(forKey: "MIDATAADDRESS") as? String
            }
        
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                self.defaults.setValue((alert?.textFields![0].text)!, forKey: "MIDATAADDRESS")
            }))
        
            
            self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    // display a alert view containing a error message when the user enters wrong information
    func displayError(){
        
        // get the main thread since the background  might trigger UI updates
        DispatchQueue.main.async(execute: {
            
            // simulate latency
            sleep(1)
        
            // create the alert
            let alert = UIAlertController(title: "Login fehlgeschlagen", message: "Ihr Benutzername oder Ihr Passwort ist falsch. Bitte versuchen Sie es erneut", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            
            // hide activity indicator
            self.loginActivity.stopAnimating()
            self.loginActivity.isHidden = true
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        })
        
    }
    
    
    
    func redirectUser(_ username : String){
        
        // get the main thread since the background  might trigger UI updates
        DispatchQueue.main.async(execute: {
        
        self.defaults.set(true, forKey: "launchedBefore")
        self.defaults.setValue(username, forKey: "USERNAME")
        self.defaults.synchronize()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController: UITabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = mainViewController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
            
        
        // simulate latency
        sleep(1)
            
        // hide activity indicator
        self.loginActivity.stopAnimating()
        self.loginActivity.isHidden = true

    })
            
    }
    

    
    
    @IBAction func saveButtonTapped(_ sender: AnyObject)
    
    {
        checkCredentials()
    }



    func checkCredentials(){
        
        
        // get & check user credentials
        if let username = userTextField.text
        {
            if let password = passwordTextField.text
            {
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [unowned self] in
                
                
                    // get the main thread since the background  might trigger UI updates
                    DispatchQueue.main.async(execute: {
                        
                        // unhide activity indicator
                        self.loginActivity.isHidden = false
                        self.loginActivity.startAnimating()
                        
                        
                    })
                    
                // authenticate using RestManager with params username & password
                RestManager.sharedInstance.authenticate(username, password: password) { (json, flag) -> Void in
                    
                    // check for error flag
                    if(!flag){
                        
                        if let token = json["authToken"].rawString() {
                            
                            self.loginSucessful = true
                            
                            // Store authToken in Keychain using Locksmith wrapper
                            
                            do {
                                try Locksmith.updateData(data: ["authToken" : token], forUserAccount: "USER")
                            }
                            catch {
                                print("data could not be stored in locksmith")
                                
                            }
                            
                        }
                    }
                        
                    else {
                    // display error message when login fails
                    self.displayError()
                    }
                    
                    // set user defaults after login so the app won't open in login view next time. redirect user to main view
                    if(self.loginSucessful)
                    {
                        self.redirectUser(username)
                    }
                 
                                   }
                } // completion block finish

            } // finish async
        }
        
    }
}
