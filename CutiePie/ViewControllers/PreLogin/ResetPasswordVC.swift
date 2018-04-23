//
//  ResetPasswordVC.swift
//  Onboarding
//
//  Created by Appinventiv on 21/09/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import UIKit

class ResetPasswordVC: BaseVc {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var resetPasswordBtn: UIButton!
    @IBOutlet weak var headingLabel :UILabel!

    
    var otp : String = ""
    var userId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func initialSetup() {
        self.headingLabel.text = StringConstants.Reset_Password.localized
        self.headingLabel.font = AppFonts.Montserrat_Bold.withSize(21)
        self.msgLabel.text = StringConstants.Please_Enter_New_Password.localized
        self.msgLabel.font = AppFonts.Montserrat_Light.withSize(15)
        self.newPasswordTextField.placeholder = StringConstants.New_Password.localized
        self.confirmPasswordTextField.placeholder = StringConstants.Confirm_Password.localized
        self.resetPasswordBtn.roundCorners()
        self.shadowView.shadowColor = UIColor.black
        self.shadowView.shadowOpacity = 0.5
        self.shadowView.shadowRadius = 10
        self.shadowView.shadowOffset = CGSize(width: 0.5 , height: 0.5)

    }
    
    fileprivate func popViewController() {
        if let vc = self.navigationController?.viewControllers[0],vc == self {
            CommonClass().gotoHome()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
   
        self.view.endEditing(true)
        if self.isDataValid {
            
            self.hitWebserviceForResetPassword()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.popViewController()
    }

}

extension ResetPasswordVC {
    
    func hitWebserviceForResetPassword() {
        
        guard let password = self.newPasswordTextField.text else {
            return
        }

        let params = ["userId" : self.userId,
                      "password" : password]
        
        WebServices.resetPasswordAPI(parameters: params, success: { [unowned self] (json) in
            
            let code = json["CODE"].intValue
            
            if code == error_codes.success{
                
                let msg = json["MESSAGE"].stringValue
                
                self.showAlert(msg: msg){
                    self.popViewController()
                }
            }else{
                let msg = json["MESSAGE"].stringValue
                self.showAlert(msg: msg)
            }
            
        }) { (e) in
            
            self.showAlert(msg: e.localizedDescription)
            
        }
    }
    
}

//MARK:- Validations
//==================
extension ResetPasswordVC {
    
    var isDataValid : Bool {
        
        guard let password = self.newPasswordTextField.text else {
            return false
        }
        guard let confirmPassword = self.confirmPasswordTextField.text else {
            return false
        }

        if password.isEmpty {
            self.showAlert(msg: StringConstants.Enter_New_Password.localized)
        }else if password.checkIfInvalid(.password) {
            self.showAlert(msg: StringConstants.Invalid_New_Password.localized)
        }else if confirmPassword.isEmpty {
            self.showAlert(msg: StringConstants.Enter_Confirm_Password.localized)
        }else if confirmPassword != password {
            self.showAlert(msg: StringConstants.Confirm_Password_Wrong.localized)
        }else{
            return true
        }
        
        return false
    }
}
