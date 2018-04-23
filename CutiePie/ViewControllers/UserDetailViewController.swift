//
//  UserDetailViewController.swift
//  Onboarding
//
//  Created by Appinventiv on 13/09/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit

class UserDetailViewController: BaseVc {

    //MARK:- IBOutlet
    //===============
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var userListButton: UIButton!
    
    //MARK:- Properties
    //=================
    var userInfo : User!

    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    
    private func initialSetup() {
        
        if self.userInfo == nil {
            
            if let userData = AppUserDefaults.value(forKey: .userData).dictionaryObject {
                self.userInfo = User(dictionary: userData)
            }
            
        }
        
        if !userInfo.imageUrl.isEmpty{
            
            userImage.imageFromURl(userInfo.imageUrl)
        }
        
        if !userInfo.first_name.isEmpty {
            
            userNameLabel.text = userInfo.first_name
        }
        self.logoutButton.setTitle(StringConstants.Logout.localized, for: .normal)
        self.changePasswordButton.setTitle(StringConstants.Change_Password.localized, for: .normal)

    }
}

//MARK:- IBActions
//================
extension UserDetailViewController {
    
    @IBAction func unwindToUserDetailViewController(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        self.logout()
    }
    
    func logout(){
        WebServices.logoutAPI(success: { (json) in
            if let errorCode = json["CODE"].int, errorCode == error_codes.success {
                AppUserDefaults.removeAllValues()
                CommonClass().gotoHome()
            }
        }) { (err) in
            
        }
    }
    
    @IBAction func userListButtonTapped(_ sender: UIButton) {
        let sceen = UserListVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(sceen, animated: true)
    }
    
    @IBAction func sideMenuButtonTapped(_ sender: UIButton) {
            openLeft()
    }
}
