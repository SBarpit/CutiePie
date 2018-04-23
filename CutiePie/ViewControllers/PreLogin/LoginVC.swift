//
//  LoginVC.swift
//  Onboarding
//
//  Created by Appinventiv on 09/09/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit
import LineSDK
import ActiveLabel
class LoginVC: BaseVc {

    //MARK:- IBOutlet
    //===============
    @IBOutlet weak var outherLoginOptionsLabel: UILabel!
    @IBOutlet weak var loginHeadingLabel: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonBackView: UIView!
    @IBOutlet weak var loginWithLine: UIButton!
    @IBOutlet weak var loginWithFacebook: UIButton!
    @IBOutlet weak var loginWithGoogle: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    //MARK:- Properties
    //=================

    var timer:Timer!
    // MARK:- IBACTIONS
    //=================
    @IBAction func loginWithLineAction(_ sender: UIButton) {
        LineSDKLogin.sharedInstance().start()
        
        
    }
    
    @IBAction func loginWithFacebookAction(_ sender: UIButton) {
        FacebookController.shared.getFacebookUserInfo(fromViewController: self, success: { (result) in
            
            print(result.name)
            print(result.email)
            print("Your profile Image Url is... \(String(describing: result.picture!))")
            
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    @IBAction func loginWithGoogle(_ sender: UIButton) {
        GoogleLoginController.shared.login(success: { (model :  GoogleUser) in
            
         print(model.name)
         print(model.email)
         print(model.image?.absoluteString)
        })
        { (err : Error) in
            print(err.localizedDescription)
        }
    }
    
    
    //MARK:- VIEW LIFE CYCLE
    //======================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LineSDKLogin.sharedInstance().delegate = self
        self.setUpFonts()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func initialSetup() {
        self.backGroundView.backgroundColor = .white
        passwordTextField.isSecureTextEntry = true
        emailTextField.keyboardType = .emailAddress
        self.backGroundView.shadowColor = UIColor.black
        self.backGroundView.shadowOpacity = 0.5
        self.backGroundView.shadowRadius = 10
        self.backGroundView.shadowOffset = CGSize(width: 0.5 , height: 0.5)
        self.viewDidLayoutSubviews()
        self.backGroundView.layer.cornerRadius = 5
        self.loginButtonBackView.roundCorners()
        self.loginWithLine.roundCorners()
        self.loginWithFacebook.roundCorners()
        self.loginWithGoogle.roundCorners()
        self.bottomView.shadowColor = UIColor.black
        self.bottomView.shadowOpacity = 0.2
        self.bottomView.shadowRadius = 10
        self.bottomView.shadowOffset = CGSize(width: 0.5, height: 0.5)
    }
    
    private func setUpFonts(){
    
        self.loginHeadingLabel.text = StringConstants.LOGIN.localized
        self.loginHeadingLabel.font = AppFonts.Montserrat_Bold.withSize(21)
        self.outherLoginOptionsLabel.text = StringConstants.or_login_with.localized
        self.outherLoginOptionsLabel.font = AppFonts.Montserrat_Light.withSize(15)
        self.emailTextField.placeholder = StringConstants.Email_Address.localized
        self.passwordTextField.placeholder = StringConstants.Password.localized
        self.forgotPasswordButton.setTitle(StringConstants.FORGOT_PASSWORD.localized, for: .normal)
        self.forgotPasswordButton.titleLabel?.font = AppFonts.Montserrat_Medium.withSize(15)
        
    }

    var checkValidityForLogin : Bool {
        
        // Comment out the check you want to skip
        
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
        
        return true
    }

    
}

extension LoginVC:LineSDKLoginDelegate {
    
    func didLogin(_ login: LineSDKLogin, credential: LineSDKCredential?, profile: LineSDKProfile?, error: Error?) {
        if (error != nil) {
            print_debug(error?.localizedDescription)
        }else{
            let accessToken = credential?.accessToken?.accessToken
            let userID:String = (profile?.userID)!
            let displayName:String = (profile?.displayName)!
            let pictureURL:URL = (profile?.pictureURL)!
            let statusMessage = profile?.statusMessage
            
            if let absolutURL:URL = pictureURL {
                let pictureUrl:String = absolutURL.absoluteString
            }
        }
    }
}

//MARK:- IBActions
//================
extension LoginVC {
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if self.checkValidityForLogin{
            
            var details = [String:Any]()
            
            details["email"] = self.emailTextField.text ?? ""
            details["password"] = self.passwordTextField.text ?? ""
            details["device_token"] = DeviceDetail.deviceToken
            details["device_id"] = DeviceDetail.device_id
            details["platform"] = "2"

            WebServices.loginAPI(parameters: details, success: { (user) -> () in

                self.showAlert(msg: user.responseString ?? StringConstants.Something_Went_Wrong.localized) {
                    CommonClass().gotoUserDetails()
                }

            }, failure: { (error : Error) -> () in
                self.showAlert(msg: error.localizedDescription)

            })
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        let sceen = ForgotPasswordVC.instantiate(fromAppStoryboard: .Login)
        self.navigationController?.pushViewController(sceen, animated: true)
    }
}

//MARK:- TextFieldDelegate
//========================
extension LoginVC: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " "{
            
            return false
        }
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
}



