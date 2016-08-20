//
//  ViewController.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 10/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController,FBSDKLoginButtonDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var udacityLoginButton: UIButton!
    @IBOutlet weak var btnFacebook: FBSDKLoginButton!

    // MARK: - View Cycles Event
    override func viewDidLoad() {
        super.viewDidLoad()
        btnFacebook.delegate = self
        configureBackground()
        configureFacebook()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        passwordTextField.hidden = true;
        emailTextField.hidden = true;
        udacityLoginButton.center.y -= 80;
    }
    
    // MARK: - IBActions
    @IBAction func loginViaUdacity(sender: UIButton) {
        if emailTextField.hidden {
            UIView.animateWithDuration(0.5,
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.1,
                                   options: [],
                                   animations: {
                                    self.udacityLoginButton.center.y += 40;
            }, completion: nil);
        
            UIView.transitionWithView(self.passwordTextField, duration: 0.6, options: [.CurveEaseOut, .TransitionFlipFromBottom], animations: {
                self.passwordTextField.hidden = false;
                self.passwordTextField.center.y += 40;
            }, completion: nil);
        
            UIView.transitionWithView(self.emailTextField, duration: 0.6, options: [.CurveEaseIn, .TransitionFlipFromTop], animations: {
                self.emailTextField.hidden = false;
                self.emailTextField.center.y += 40;
            }, completion: nil);
        }
        else{
            //TODO: Add checks on Email and password
            let credential = Credential(username: emailTextField.text!, password: passwordTextField.text!, token: "", authProvider: ParseClient.AuthenticationProvider.Udacity)
            login(credential)
        }
    }
    
    // MARK: - FBSDKLoginButtonDelegate Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if(error != nil){
            
        }
        else{
            if let token = FBSDKAccessToken.currentAccessToken(){
                
                print("Token Is \(token.tokenString)")
                let credential =  Credential(username: "", password: "", token: token.tokenString, authProvider: ParseClient.AuthenticationProvider.Facebook)
                
                login(credential)
            }
            else{
                print("No token recieved")
            }
            
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Log out called");
    }

    // MARK: - Private Methods
    func configureFacebook()
    {
        btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
        btnFacebook.delegate = self;
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
    
    func login(credential:Credential) {
        ParseClient.sharedInstance().getAuthenticationData(credential){ (authData, error) in
            if error == nil{
                
                ParseClient.sharedInstance().getStudentPublicUdacityProfile((authData?.user_key)!){ (profile, error) in
                    performUIUpdatesOnMain{
                        (UIApplication.sharedApplication().delegate as! AppDelegate).authData = authData
                        (UIApplication.sharedApplication().delegate as! AppDelegate).authProvider = credential.authProvider
                        let controller = self.storyboard!.instantiateViewControllerWithIdentifier(ParseClient.StoryBoardIds.TabbarView) as! UITabBarController
                        self.presentViewController(controller, animated: true, completion: nil)
                    }
                    
                    if error == nil{
                        (UIApplication.sharedApplication().delegate as! AppDelegate).userProfile = profile
                    }
                }
                
            }
            else{
                performUIUpdatesOnMain{
                    let userInfo = error?.userInfo;
                    let errorMessage = userInfo![NSLocalizedDescriptionKey] as! String;
                    let alertViewController = UIAlertController(title: "Login Failed", message: errorMessage, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alertViewController.addAction(okAction)
                    self.presentViewController(alertViewController, animated: true, completion: nil);
                }
            }
        }
    }
//    func returnUserData(token:String)
//    {
//
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,interested_in,gender,birthday,email,age_range,name,picture.width(480).height(480)"])
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            
//            if ((error) != nil)
//            {
//                print("Error: \(error)")
//            }
//            else
//            {
//                print("fetched user: \(result)")
//                let id : NSString = result.valueForKey("id") as! String
//                print("User ID is: \(id)")
//            }
//        })
//    }
}

