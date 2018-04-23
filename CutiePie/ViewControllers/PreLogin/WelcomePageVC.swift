//
//  WelcomePageVC.swift
//  CutiePie
//
//  Created by Appinventiv Mac on 18/04/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit


class WelcomePageVC: UIViewController {
    
    // MARK:- VARIABLES
    //====================
    
    
    // MARK:- IBOUTLETS
    //====================
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    // MARK:- IBACTIONS
    //====================
    @IBAction func skipToGuestLogin(_ sender: UIButton) {
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        let sceen = LoginVC.instantiate(fromAppStoryboard: .Login)
        self.navigationController?.pushViewController(sceen, animated: true)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        let sceen = SignUpVC.instantiate(fromAppStoryboard: .Login)
        self.navigationController?.pushViewController(sceen, animated: true)
    }
}

// MARK:- LIFE CYCLE
//====================
extension WelcomePageVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}



// MARK:- FUNCTIONS
//====================
extension WelcomePageVC {
    
    /// Invite Page Content Initial Setup
    private func initialSetup() {
        
        self.loginButton.layer.cornerRadius = 5
        self.registerButton.layer.cornerRadius = 8
        navigationController?.hidesBarsOnTap = true

        
    }
}
