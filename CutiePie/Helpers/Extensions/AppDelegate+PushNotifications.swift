//
//  AppDelegate+PushNotifications.swift
//  Onboarding
//
//  Created by Appinventiv on 13/11/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import SwiftyJSON
import Firebase

//MARK:
//MARK: Remote push notification methods/delegates
extension AppDelegate:UNUserNotificationCenterDelegate{
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        NSLog("User Info didReceive = ",response.notification.request.content.userInfo)
        
        //        self.pushAction(forInfo: response.notification.request.content.userInfo)
        
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        NSLog("User Info willPresent = ",notification.request.content.userInfo)
        
        completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        NSLog("User Info didReceive = ",userInfo)
        
        guard (userInfo["aps"] as? [String : Any]) != nil else{
            return
        }
        
        if application.applicationState == .inactive {
            
            self.pushAction(forInfo: userInfo, state: application.applicationState)
            
        }else{
            
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
        Auth.auth().setAPNSToken(deviceToken, type: .prod)

//        var deviceTokenString:String?
        //        if #available(iOS 10.0, *) {
        //            let dToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        //            deviceTokenString = "\(dToken)"
        //        }
        //        else {
        //            let characterSet: CharacterSet = CharacterSet(charactersIn: "<>")
        //            let dToken = deviceToken.description.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "")
        //            deviceTokenString = "\(dToken)"
        //        }
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        //deviceTokenString = "\(token)"
        DeviceDetail.deviceToken = token
        
        NSLog("%@", "Decice token = \(token)")
        
        self.window?.rootViewController?.showAlert(msg: token)

    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    func registerForPushNotification(){

        if #available(iOS 10.0, *) {
                let center  = UNUserNotificationCenter.current()
                center.delegate = self
                center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                    if error == nil{
                        
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            } else {
                
                let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.registerForRemoteNotifications()
            }
    }
    
    func pushAction(forInfo userInfo : [AnyHashable: Any],state : UIApplicationState){
        
        guard let aps = userInfo["aps"] as? [String : Any] else{
            return
        }
        if let type = aps["type"] ,let pushType : PushType = PushType(rawValue: "\(type)"){
            
            
        }
    }
}

enum PushType : String {
    
    case push
}
