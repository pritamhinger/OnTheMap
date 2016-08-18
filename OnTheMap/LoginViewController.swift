//
//  ViewController.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 10/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var udacityLoginButton: UIButton!

    // MARK: - View Cycles Event
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground();
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
            let credential = Credential(username: emailTextField.text!, password: passwordTextField.text!)
            ParseClient.sharedInstance().getAuthenticationData(credential){ (authData, error) in
                if error == nil{
                    performUIUpdatesOnMain{
                        (UIApplication.sharedApplication().delegate as! AppDelegate).authData = authData
                        let controller = self.storyboard!.instantiateViewControllerWithIdentifier(ParseClient.StoryBoardIds.TabbarView) as! UITabBarController
                        self.presentViewController(controller, animated: true, completion: nil)
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

