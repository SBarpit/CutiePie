//
//  SignUpVC.swift
//  Onboarding
//
//  Created by Appinventiv on 09/09/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit

class SignUpVC: BaseVc {
    
    //MARK:- IBOutlet
    //===============
    
    @IBOutlet weak var emailVeryfyImage: UIImageView!
    @IBOutlet weak var otherRegisterOptionsLabel: UILabel!
    @IBOutlet weak var registerHeadingLabel: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var referralCodeTextField: UITextField!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButtonBackView: UIView!
    @IBOutlet weak var registerWithLine: UIButton!
    @IBOutlet weak var registerWithFacebook: UIButton!
    @IBOutlet weak var registerWithGoogle: UIButton!
    
    
    
    //MARK:- Properties
    //=================
    
    fileprivate var checkValidateForSinnUp : Bool {
        
        if let email = self.emailTextField.text,!email.isEmpty{
            
            if email.checkIfInvalid(.email) {
                
                self.showAlert(msg: StringConstants.Invalid_Email.localized)
                return false
            }
        } else {
            
            self.showAlert(msg: StringConstants.Enter_Email.localized)
            return false
            
        }
        
        if let password = self.passwordTextField.text,!password.isEmpty {
            
            if password.checkIfInvalid(ValidityExression.password) {
                
                self.showAlert(msg: StringConstants.Invalid_Password.localized)
                return false
            }
        } else {
            
            self.showAlert(msg: StringConstants.Enter_Password.localized)
            return false
            
        }
        if let confirmPassword = self.confirmPasswordTextField.text,!confirmPassword.isEmpty {
            if confirmPassword != self.passwordTextField.text {
                self.showAlert(msg: StringConstants.Confirm_Password_Wrong.localized)
                return false
        }
        }else{
            self.showAlert(msg: StringConstants.Enter_Confirm_Password.localized)
            return false
        }
        
        return true
    }
        
    

    
    // MARK:- IBACTIONS
    //=================
    @IBAction func registerWithLineAction(_ sender: UIButton) {
    }
    
    @IBAction func registerWithFacebookAction(_ sender: UIButton) {
        
        FacebookController.shared.getFacebookUserInfo(fromViewController: self, success: { (result) in
            
            print(result.name)
            print(result.email)
            print("Your profile Image Url is... \(String(describing: result.picture!))")
            
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    @IBAction func registerWithGoogle(_ sender: UIButton) {
        
        GoogleLoginController.shared.login(success: { (model :  GoogleUser) in
            
            print(model.name)
            print(model.email)
            print(model.image?.absoluteString)
        })
        { (err : Error) in
            print(err.localizedDescription)
        }
    }

    @IBAction func normalSignUp(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if self.checkValidateForSinnUp{
            
            var details = [String:Any]()
            
            details["email"] = self.emailTextField.text ?? ""
            details["password"] = self.passwordTextField.text ?? ""
            details["device_token"] = DeviceDetail.deviceToken
            details["device_id"] = DeviceDetail.device_id
            details["platform"] = "2"
            
            WebServices.signUpAPI(parameters: details, success: { (user) -> () in
                
                self.showAlert(msg: user.responseString ?? StringConstants.Something_Went_Wrong.localized) {
                    CommonClass().gotoUserDetails()
                }
                
            }, failure: { (error : Error) -> () in
                self.showAlert(msg: error.localizedDescription)
                self.showAlert(msg: StringConstants.email_exists.localized)
            })
        }
    }
}

//MARK:- LIFE CYCLE METHODS
//=========================

extension SignUpVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUp()
        self.setUpFonts()
        
    }
    
       override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }

}

// MARK:- FUNCTIONS
//================

extension SignUpVC {
    
    private func initialSetUp(){
        
        self.backGroundView.backgroundColor = .white
        passwordTextField.isSecureTextEntry = true
        emailTextField.keyboardType = .emailAddress
        self.backGroundView.shadowColor = AppColors.shadowColor
        self.backGroundView.shadowOpacity = 0.5
        self.backGroundView.shadowRadius = 10
        self.backGroundView.shadowOffset = CGSize(width: 0.0 , height: 0.0)
        self.backGroundView.layer.cornerRadius = 5
        self.loginButtonBackView.roundCorners()
        self.registerWithLine.roundCorners()
        self.registerWithFacebook.roundCorners()
        self.registerWithGoogle.roundCorners()
        self.buttomView.shadowColor = UIColor.black
        self.buttomView.shadowOpacity = 0.2
        self.buttomView.shadowRadius = 10
        self.buttomView.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
    }
    
    private func setUpFonts(){
        
        self.emailTextField.placeholder = StringConstants.Email_Address.localized
        self.passwordTextField.placeholder = StringConstants.Password.localized
        self.confirmPasswordTextField.placeholder = StringConstants.Confirm_Password.localized
        self.registerHeadingLabel.text = StringConstants.Register.localized
        self.registerHeadingLabel.font = AppFonts.Montserrat_Bold.withSize(21)
        self.otherRegisterOptionsLabel.text = StringConstants.or_register_with.localized
        self.otherRegisterOptionsLabel.font = AppFonts.Montserrat_Light.withSize(15)
        
    }

}

extension SignUpVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField === self.emailTextField {
            var data = [String:Any]()
            data["email"] = textField.text
            let email = textField.text
            if (email?.checkIfInvalid(.email))!{
               self.showAlert(msg: StringConstants.Invalid_Email.localized)
            }else{
            WebServices.checkEmail(parameters: data, success: { (flag) in
                if flag {
                    self.emailVeryfyImage.isHidden = false
                }
            }, failure: { (flag) in
                if flag {
                    self.emailVeryfyImage.isHidden = true
                    self.showAlert(msg: StringConstants.email_exists.localized)
                }
            })
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === self.emailTextField {
            self.emailVeryfyImage.isHidden = true
        }
    }
}



