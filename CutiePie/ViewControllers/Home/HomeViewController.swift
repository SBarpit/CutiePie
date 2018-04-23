//
//  HomeViewController.swift
//  Onboarding
//
//  Created by Appinventiv on 13/09/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit

class HomeViewController: BaseVc {

    //MARK:- IBOutlet
    //===============
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    
    private func initialSetup() {

        self.loginButton.setTitle(StringConstants.LOGIN.localized, for: .normal)
//        self.signupButton.setTitle(StringConstants.SIGNUP.localized, for: .normal)
    }
}

//MARK:- IBActions
//================
extension HomeViewController {
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        let signUpScene = SignUpVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(signUpScene, animated: true)
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        let signUpScene = LoginVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(signUpScene, animated: true)
        
    }

}
