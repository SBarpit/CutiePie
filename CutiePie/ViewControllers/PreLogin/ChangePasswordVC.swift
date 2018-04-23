//
//  ChangePasswordVC.swift
//  Onboarding
//
//  Created by Appinventiv on 15/09/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ChangePasswordData {
    
    var newPassword : String = ""
    var oldPassword : String = ""
    var confirmPassword : String = ""
    
}
class ChangePasswordVC: BaseVc {
    
    //MARK:- IBOutlet
    //===============
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK:- Properties
    //=================
    var userData = ChangePasswordData()
    
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    private func initialSetup() {
        
        self.newPasswordTextField.placeholder = StringConstants.New_Password.localized
        self.confirmPasswordTextField.placeholder = StringConstants.Confirm_Password.localized
        self.changePasswordButton.setTitle(StringConstants.CHANGE_PASSWORD.localized, for: .normal)
        self.backButton.setTitle(StringConstants.Back.localized, for: .normal)
        
    }
    
}

//MARK:- IBActions
//================
extension ChangePasswordVC {
    
    @IBAction func oldPasswordEditingChanged(_ sender: UITextField) {
        self.userData.oldPassword = sender.text ?? ""
    }
    
    @IBAction func newPasswordEditingChanged(_ sender: UITextField) {
        self.userData.newPassword = sender.text ?? ""
    }
    
    @IBAction func confirmPasswordEditingChanged(_ sender: UITextField) {
        self.userData.confirmPassword = sender.text ?? ""
    }
    
    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if self.isDataValid {
            
            self.hitWebserviceForChangePassword()
            
        }
    }
}

//MARK:- WebService
//=================

extension ChangePasswordVC {
    
    func hitWebserviceForChangePassword() {
        
        WebServices.changePasswordAPI(parameters: self.userData, success: { [unowned self] (json) in
            
            let code = json["CODE"].intValue
            
            if code == error_codes.success{
                
                let msg = json["MESSAGE"].stringValue
                self.showAlert(msg: msg){
                    self.performSegue(withIdentifier: "unwindToUserDetailViewControllerWithSegueID", sender: self)
                }
            }else{
                let msg = json["MESSAGE"].stringValue
                self.showAlert(msg: msg){
                    
                }
            }
            
        }) { (e) in
            
            self.showAlert(msg: e.localizedDescription)
            
        }
    }
    
}

//MARK:- Validations
//==================
extension ChangePasswordVC {
    
    var isDataValid : Bool {
        
         if self.userData.oldPassword.checkIfInvalid(.password) {
            self.showAlert(msg: StringConstants.Invalid_Old_Password.localized)
        }else if self.userData.newPassword.isEmpty {
            self.showAlert(msg: StringConstants.Enter_New_Password.localized)
        }else if self.userData.newPassword.checkIfInvalid(.password) {
            self.showAlert(msg: StringConstants.Invalid_New_Password.localized)
        }else if self.userData.confirmPassword.isEmpty {
            self.showAlert(msg: StringConstants.Enter_Confirm_Password.localized)
        }else if self.userData.confirmPassword != self.userData.newPassword {
            self.showAlert(msg: StringConstants.Confirm_Password_Wrong.localized)
        }else{
            return true
        }
        
        return false
    }
}
