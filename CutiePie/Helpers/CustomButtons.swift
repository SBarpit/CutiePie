//
//  CustomButtons.swift
//  DittoFashionMarketBeta
//
//  Created by Bhavneet Singh on 22/11/17.
//  Copyright © 2017 Bhavneet Singh. All rights reserved.
//

import Foundation
import UIKit
import TransitionButton

class CustomButton: TransitionButton {

    enum ButtonType { case green, white }
    
    var btnType: ButtonType = .green {
        didSet{
            self.initialSetup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initialSetup()
    }
    
    private func initialSetup() {

        self.cornerRadius = 3
        self.layer.cornerRadius = 3
        //self.layer.borderColor = AppColors.whiteColor.cgColor
        self.layer.borderWidth = 0.2
        self.titleLabel?.textAlignment = .center
//        self.sha
        //self.backgroundColor = btnType == .green ? AppColors.themeColor : AppColors.whiteColor
        //self.setTitleColor(btnType == .green ? AppColors.whiteColor : AppColors.themeColor, for: .normal)
        //self.titleLabel?.font = AppFonts.ProximaNova_Semibold.withSize(16)
    }
    
    func stopAnimationNormal(title: String, completion: (() -> ())? = nil) {
        self.stopAnimation(animationStyle: .normal, revertAfterDelay: 1) {
            DispatchQueue.delay(1.1, closure: {
                self.setTitle(title, for: .normal)
                completion?()
            })
        }
    }
    
    func stopAnimationExpand(title: String, completion: (() -> ())? = nil) {
        self.stopAnimation(animationStyle: .expand, revertAfterDelay: 1) {
            DispatchQueue.delay(1.1, closure: {
                self.setTitle(title, for: .normal)
                completion?()
            })
        }
    }

    func stopAnimationShake(title: String, completion: (() -> ())? = nil) {
        self.stopAnimation(animationStyle: .shake, revertAfterDelay: 1) {
            DispatchQueue.delay(1.1, closure: {
                self.setTitle(title, for: .normal)
                completion?()
            })
        }
    }
}
