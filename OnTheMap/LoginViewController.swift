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
                                   delay: 0.5,
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
            let jsonBody = "{\"udacity\":{\"username\":\"\(emailTextField.text!)\", \"password\":\"\(passwordTextField.text!)\"}}";
            ParseClient.sharedInstance().taskForLogin(ParseClient.UdacityMethods.Session, jsonBody: jsonBody){ (result, error) in
                if error == nil{
                    let parameters = [ParseClient.ParseParameterKeys.Limit:"100"];
                    ParseClient.sharedInstance().taskForGetMethod(ParseClient.ParseMethods.StudentLocation, parameters: parameters){ (results, error) in
                        if error == nil{
                            if let result = results[ParseClient.StudentReponseKeys.Results] as? [[String:AnyObject]]{
                                let students = Student.parseStudentJSON(result);
                                print("Student count is : \(students.count)");
                            }
                        }
                        else{
                            print(error)
                        }
                    }
                }
                else{
                    print(error);
                }
            }
        }
    }
    
}

