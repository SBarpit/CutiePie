//
//  CommonClass.swift
//  Onboarding
//
//  Created by Anuj on 9/15/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class CommonClass {
    
    func gotoHome() {
        let sceen = HomeViewController.instantiate(fromAppStoryboard: .Main)
        self.gotoViewController(sceen)
    }
    
    func gotoUserDetails() {
        let sceen = UserDetailViewController.instantiate(fromAppStoryboard: .Main)
        self.gotoViewController(sceen,sideMenu: true)
    }
    
    func gotoViewController(_ vc : BaseVc,sideMenu : Bool = false) {
        
        if sideMenu {
            let leftMenuViewController = SideMenuVC.instantiate(fromAppStoryboard: .Main)
            let mainViewController = vc
            let nvc = UINavigationController(rootViewController: mainViewController)
            nvc.isNavigationBarHidden = true

            let leftslideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftMenuViewController)

            sharedAppDelegate.window?.rootViewController = leftslideMenuController
            sharedAppDelegate.window?.makeKeyAndVisible()

        }else {
            let nvc = UINavigationController(rootViewController: vc)
            nvc.isNavigationBarHidden = true

            sharedAppDelegate.window?.rootViewController = nvc
            sharedAppDelegate.window?.makeKeyAndVisible()
        }
    }
    
}
