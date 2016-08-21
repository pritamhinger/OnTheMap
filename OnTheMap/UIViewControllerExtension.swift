//
//  UIViewControllerExtension.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 21/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

extension UIViewController{
    func login(credential:Credential, facebookBtnView:UIView) {
        ParseClient.sharedInstance().getAuthenticationData(credential){ (authData, error) in
            if error == nil{
                
                ParseClient.sharedInstance().getStudentPublicUdacityProfile((authData?.user_key)!){ (profile, error) in
                    performUIUpdatesOnMain{
                        (UIApplication.sharedApplication().delegate as! AppDelegate).authData = authData
                        (UIApplication.sharedApplication().delegate as! AppDelegate).authProvider = credential.authProvider
                        
                        if facebookBtnView.hidden{
                            facebookBtnView.hidden = false
                        }
                        
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
                    let errorMessage = ParseClient.sharedInstance().extractUserFriendlyErrorMessage(error!)
                    ParseClient.sharedInstance().showError(self, message: errorMessage, title: "Login Failed", style: .Alert)
                }
            }
        }
    }
}