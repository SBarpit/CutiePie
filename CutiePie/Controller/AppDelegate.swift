//
//  AppDelegate.swift
//  Onboarding
//
//  Created by Gurdeep Singh on 04/07/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import FBSDKCoreKit
import LineSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let kClientID = "1090135862851-6ib47rlh8nhqibcdlmpm0lrsk3u7jiif.apps.googleusercontent.com"
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
       
       // let tutorialDisplayed = AppUserDefaults.value(forKey: .tutorialDisplayed).stringValue
        
//        if !tutorialDisplayed.isEmpty {
//
//            if AppUserDefaults.value(forKey: .userData) != JSON.null {
//
//                CommonClass().gotoUserDetails()
//            }else {
//                CommonClass().gotoHome()
//            }
//        }
        
        //application.registerForRemoteNotifications()
        //MARK: Google login related...
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GoogleLoginController.shared.configure(withClientId: kClientID)
        //FirebaseApp.configure()

       // self.registerForPushNotification()
        
        return true
    }

        
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        //MARK: Facebook related
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let lineDidHandel = LineSDKLogin.sharedInstance().handleOpen(url)
        let googleDidHandle = GoogleLoginController.shared.handleUrl(url, options: options)
        
        let facebookDidHandle =  FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL!,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation] as Any
        )
        
        return googleDidHandle || facebookDidHandle || lineDidHandel

        
        
        
        
        
        
//        return GoogleLoginController.shared.handleUrl(url, options: options)
//        if url.scheme?.lowercased() == "projectname" {
//
//            let urlString = url.absoluteString
//
//            if let userId = urlString.components(separatedBy: "userId/").last  {
//
//                let sceen = ResetPasswordVC.instantiate(fromAppStoryboard: .Main)
//                sceen.userId = userId
//                CommonClass().gotoViewController(sceen)
//            }
//        }else{
        
//        }
//        
//        return true
    }
    

}

