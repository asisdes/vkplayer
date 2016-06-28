//
//  LoginForm.swift
//  SimpleVKPlayer
//
//  Created by admin on 26.06.16.
//  Copyright © 2016 Yukupov Aziz. All rights reserved.
//

import UIKit
import VK_ios_sdk

class LoginForm : UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    let SCOPE = [VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES]
    @IBOutlet weak var logInBtn: UIButton!
    
    
    @IBAction func logInBtn(sender: UIButton) {
        
        VKSdk.wakeUpSession(SCOPE) { (state : VKAuthorizationState, error : NSError!) in
            switch state {
            /// Authorization state unknown, probably ready to work or something went wrong
            case .Unknown : print("Unknown")
            /// SDK initialized and ready to authorize
            case .Initialized : print("Initialized");  VKSdk.authorize(self.SCOPE)
            /// Authorization state pending, probably we're trying to load auth information
            case .Pending : print("Pending")
            /// Started external authorization process
            case .External : print("External")
            /// Started in app authorization process, using SafariViewController
            case .SafariInApp : print("SafariInApp")
            /// Started in app authorization process, using webview
            case .Webview : print("Webview")
            /// User authorized
            case .Authorized : print("Authorized"); self.skipToView();
            /// An error occured, try to wake up session later
            case .Error : print("Error")
            }
        }
        
        let isLogged = VKSdk.isLoggedIn()
        if isLogged == true {
            print("Пользователь авторизован")
        } else if isLogged == false {
            print("Пользователь не авторизован")
            //VKSdk.authorize(SCOPE)
        }
        
    }
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
        let sdkInstance : VKSdk = VKSdk.initializeWithAppId("5111052")
        
        sdkInstance.registerDelegate(self)
        sdkInstance.uiDelegate = self
        
        VKSdk.wakeUpSession(SCOPE) { (state : VKAuthorizationState, error : NSError!) in
            switch state {
            /// Authorization state unknown, probably ready to work or something went wrong
            case .Unknown : print("Unknown")
            /// SDK initialized and ready to authorize
            case .Initialized : print("Initialized");  //VKSdk.authorize(self.SCOPE)
            /// Authorization state pending, probably we're trying to load auth information
            case .Pending : print("Pending")
            /// Started external authorization process
            case .External : print("External")
            /// Started in app authorization process, using SafariViewController
            case .SafariInApp : print("SafariInApp")
            /// Started in app authorization process, using webview
            case .Webview : print("Webview")
            /// User authorized
            case .Authorized : print("Authorized"); self.skipToView()
            /// An error occured, try to wake up session later
            case .Error : print("Error")
            }
        }
        let isLogged = VKSdk.isLoggedIn()
        if isLogged == true {
            print("Пользователь авторизован")
        } else if isLogged == false {
            print("Пользователь не авторизован")
            //VKSdk.authorize(SCOPE)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func skipToView() {
        let VC1 = self.storyboard!.instantiateViewControllerWithIdentifier("Main") as! ViewController
        self.navigationController!.pushViewController(VC1, animated: true)
    }

    func vkSdkShouldPresentViewController(controller: UIViewController) {
        print("vkSdkShouldPresentViewController")
        self.navigationController?.topViewController?.presentViewController(controller, animated: true, completion: nil)
        self.skipToView()
        /*
        self.navigationController?.topViewController?.presentViewController(controller, animated: true, completion: {
            self.skipToView()
        })
        */
       
        
    }
    
    func vkSdkAccessAuthorizationFinishedWithResult(result: VKAuthorizationResult!) {
        
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("vkSdkUserAuthorizationFailed")
    }
    
    
    func vkSdkNeedCaptchaEnter(captchaError: VKError) { }
    func vkSdkTokenHasExpired(expiredToken: VKAccessToken) { }
    func vkSdkUserDeniedAccess(authorizationError: VKError) { }
    func vkSdkReceivedNewToken(newToken: VKAccessToken) {
        print("Token \(newToken)")
    }
    
}
