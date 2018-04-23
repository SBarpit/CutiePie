//
//  ForgotPasswordVC.swift
//  Onboarding
//
//  Created by Appinventiv on 15/09/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseVc {

    
    //MARK:- IBOutlet
    //===============
    
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var otp : Int = 0
    
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }

    private func initialSetup() {
        
        self.emailTextField.placeholder = StringConstants.Email_Address.localized
        self.continueButton.roundCorners()
        self.shadowView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.shadowView.layer.shadowOpacity = 0.2
        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.shadowView.layer.shadowRadius = 5
        self.shadowView.cornerRadius = 5
        self.shadowView.clipsToBounds = false

    }
}

//MARK:- IBActions
//================
extension ForgotPasswordVC {
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        
        if self.isDataValid {
            self.hitWebserviceForForgotPassword()
        }
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- WebService
//=================

extension ForgotPasswordVC {
    
    func hitWebserviceForForgotPassword() {
        
        guard let text = self.emailTextField.text else {
            return
        }
        
        WebServices.forgotPasswordAPI(email: text, success: { [unowned self] (json) in
            
            let code = json["CODE"].intValue
            
            if code == error_codes.success{
                
                let msg = json["MESSAGE"].stringValue
                
                let result = json["RESULT"]
                
                if let otp = result["otp"].int {
                    
                    self.otp = otp
                    print_debug(otp)
                }
                
                self.showAlert(msg: msg){
                    self.navigationController?.popViewController(animated: true)
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
extension ForgotPasswordVC {
    
    var isDataValid : Bool {
        
        guard let text = self.emailTextField.text else {
            return false
        }
        
        if text.isEmpty {
            self.showAlert(msg: StringConstants.Enter_Email.localized)
        }else if text.checkIfInvalid(.email) {
            self.showAlert(msg: StringConstants.Invalid_Email.localized)
        }else{
            return true
        }
        
        return false
    }
}
