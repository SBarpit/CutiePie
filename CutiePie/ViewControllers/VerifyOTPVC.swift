//
//  VerifyOTPVC.swift
//  Onboarding
//
//  Created by Appinventiv on 06/11/17.
//  Copyright © 2017 Gurdeep Singh. All rights reserved.
//

import UIKit
import Firebase

class VerifyOTPVC: UIViewController {

    @IBOutlet weak var enterOtpLabel: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var user : User!
    var verificationID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.enterOtpLabel.text = "Please Enter OTP sent to mobile no \(self.user.phone)"
        self.otpTextField.placeholder = "Enter OTP"
        self.submitButton.setTitle("Submit", for: .normal)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(self.user.country_code + self.user.phone, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error)
                self.showAlert(msg: error.localizedDescription)
            } else {
                self.verificationID = verificationID ?? ""
                // Sign in using the verificationID and the code sent to the user
                // ...
            }
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if let text = otpTextField.text,!text.isEmpty {
            
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: text)
            
            AppNetworking.showLoader()
            
            Auth.auth().signIn(with: credential) { (user, error) in
                
                AppNetworking.hideLoader()
                
                if let error = error {
                    self.showAlert(msg: error.localizedDescription)
                } else {
                    AppUserDefaults.save(value: self.user.dictionary(), forKey: .userData)
                    CommonClass().gotoUserDetails()
                }
            }
        }else{
            self.showAlert(msg: "Please enter OTP")
        }
    }
}
