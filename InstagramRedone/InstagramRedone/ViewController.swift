//
//  ViewController.swift
//  InstagramRedone
//
//  Created by Ethan Hess on 12/4/15.
//  Copyright © 2015 Ethan Hess. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var signupActive = true
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var registeredText: UILabel!
    @IBOutlet var loginButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() == nil {
            
            self.performSegueWithIdentifier("login", sender: self)
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            
            displayAlert("Error in form", message: "Please enter a username and password")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later"
            
            if signupActive == true {
                
                let user = PFUser()
                user.username = username.text
                user.password = password.text
                
                //sign up user
                
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        
                        // Signup successful
                        
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                            
                        }
                        
                        self.displayAlert("Failed SignUp", message: errorMessage)
                    }
                })
                
            } else {
                    
                    PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        if user != nil {
                            
                            // Logged In!
                            self.performSegueWithIdentifier("login", sender: self)
                            
                        } else {
                            
                            if let errorString = error!.userInfo["error"] as? String {
                                
                                errorMessage = errorString
                            }
                            self.displayAlert("Failed Login", message: errorMessage)
                        }
                    })
                }
            }
        }
    
    
    @IBAction func login(sender: AnyObject) {
        
        if signupActive == true {
            
            signupButton.setTitle("Log In", forState: UIControlState.Normal)
            registeredText.text = "Not registered?"
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            signupActive = false
            
        } else {
            
            signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
            registeredText.text = "Already registered?"
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            signupActive = true
        }
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

