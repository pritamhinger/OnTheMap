//
//  ViewController.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 10/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController,FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var udacityLoginButton: UIButton!
    @IBOutlet weak var btnFacebook: FBSDKLoginButton!
    @IBOutlet weak var signInDifferently: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    // MARK: - View Cycles Event
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        btnFacebook.delegate = self
        configureFacebook()
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tap(_:)))
        view.addGestureRecognizer(tapGestureReconizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        passwordTextField.hidden = true
        emailTextField.hidden = true
        signUpButton.hidden = true
        signInDifferently.hidden = true
        udacityLoginButton.center.y -= 80
        btnFacebook.center.y -= 80
    }
    
    // MARK: - IBActions
    @IBAction func loginViaUdacity(sender: UIButton) {
        if emailTextField.hidden {
            UIView.animateWithDuration(0.2, animations: {
                self.btnFacebook.hidden = true
                self.signInDifferently.hidden = false
                self.signInDifferently.center.y += 45
                self.btnFacebook.center.y += 40
            })
            
            UIView.animateWithDuration(0.5,
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.1,
                                   options: [],
                                   animations: {
                                    self.udacityLoginButton.center.y += 40
                                    self.signUpButton.hidden = false
                                    self.signUpButton.center.y = self.udacityLoginButton.center.y + 45
            }, completion: nil)
        
            UIView.transitionWithView(self.passwordTextField, duration: 0.6, options: [.CurveEaseOut, .TransitionFlipFromBottom], animations: {
                self.passwordTextField.hidden = false
                self.passwordTextField.center.y += 40
            }, completion: nil)
        
            UIView.transitionWithView(self.emailTextField, duration: 0.6, options: [.CurveEaseIn, .TransitionFlipFromTop], animations: {
                self.emailTextField.hidden = false
                self.emailTextField.center.y += 40
            }, completion: nil)
        }
        else{
            if emailTextField.text?.characters.count == 0 || passwordTextField.text?.characters.count == 0{
                ParseClient.sharedInstance().showError(self, message: "Username and password are required", title: "", style: .Alert)
                return
            }
            let credential = Credential(username: emailTextField.text!, password: passwordTextField.text!, token: "", authProvider: ParseClient.AuthenticationProvider.Udacity)
            login(credential, facebookBtnView: self.btnFacebook)
        }
    }
    
    @IBAction func showSignInOptions(sender: UIButton) {
        
        UIView.animateWithDuration(0.5,
                                   delay: 0.3,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.1,
                                   options: [],
                                   animations: {
                                    self.udacityLoginButton.center.y -= 40
                                    self.btnFacebook.center.y -= 40
                                    self.signUpButton.hidden = true
                                    self.signUpButton.center.y = self.udacityLoginButton.center.y - 45
                                    self.btnFacebook.hidden = false
                                    self.signInDifferently.hidden = true
                                    self.signInDifferently.center.y -= 45
            }, completion: nil)
        
        UIView.transitionWithView(self.passwordTextField, duration: 0.6, options: [.CurveEaseOut, .TransitionFlipFromBottom], animations: {
            self.passwordTextField.hidden = true
            self.passwordTextField.center.y -= 40
            }, completion: nil)
        
        UIView.transitionWithView(self.emailTextField, duration: 0.6, options: [.CurveEaseIn, .TransitionFlipFromTop], animations: {
            self.emailTextField.hidden = true
            self.emailTextField.center.y -= 40
            }, completion: nil)
        
    }
    
    @IBAction func signUpButtonClicked(sender: UIButton) {
        let url = NSURL(string: ParseClient.UdacityAPI.SignUpURL)
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    // MARK: - UITextField Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - FBSDKLoginButtonDelegate Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if(error != nil){
            let errorMessage = ParseClient.sharedInstance().extractUserFriendlyErrorMessage(error)
            ParseClient.sharedInstance().showError(self, message: errorMessage, title: "Login", style: .Alert)
        }
        else{
            if let token = FBSDKAccessToken.currentAccessToken(){
                
                print("Token Is \(token.tokenString)")
                let credential =  Credential(username: "", password: "", token: token.tokenString, authProvider: ParseClient.AuthenticationProvider.Facebook)
                
                login(credential, facebookBtnView: self.btnFacebook)
            }
            else{
                print("No token recieved")
            }
            
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }

    // MARK: - Tap Gesture Event
    func tap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    func configureFacebook()
    {
        btnFacebook.readPermissions = ["public_profile", "email", "user_friends"]
        btnFacebook.delegate = self
    }
    
    private func configureBackground() {
        let backgroundGradient = CAGradientLayer()
        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
    }
}

