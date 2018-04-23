//
//  AppFonts.swift
//  DannApp
//
//  Created by Aakash Srivastav on 20/04/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import UIKit


enum AppFonts : String {
    
    case Montserrat_Black = "Montserrat-Black"
    case Montserrat_BlackItalic = "Montserrat-BlackItalic"
    case Montserrat_Bold = "Montserrat-Bold"
    case Montserrat_BoldItalic = "Montserrat-BoldItalic"
    case Montserrat_ExtraBold = "Montserrat-ExtraBold"
    case Montserrat_ExtraBoldItalic = "Montserrat-ExtraBoldItalic"
    case Montserrat_ExtraLight = "Montserrat-ExtraLight"
    case Montserrat_ExtraLightItalic = "Montserrat-ExtraLightItalic"
    case Montserrat_Italic = "Montserrat-Italic"
    case Montserrat_Light = "Montserrat-Light"
    case Montserrat_LightItalic = "Montserrat-LightItalic"
    case Montserrat_Medium = "Montserrat-Medium"
    case Montserrat_MediumItalic = "Montserrat-MediumItalic"
    case Montserrat_Regular = "Montserrat-Regular"
    case Montserrat_SemiBold = "Montserrat-SemiBold"
    case Montserrat_SemiBoldItalic = "Montserrat-SemiBoldItalic"
    case Montserrat_Thin = "Montserrat-Thin"
    case Montserrat_ThinItalic = "Montserrat-ThinItalic"
}

extension AppFonts {
    
    func withSize(_ fontSize: CGFloat) -> UIFont {
        
        return UIFont(name: self.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    func withDefaultSize() -> UIFont {
        
        return UIFont(name: self.rawValue, size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
    
}

// USAGE : let font = AppFonts.Helvetica.withSize(13.0)
// USAGE : let font = AppFonts.Helvetica.withDefaultSize()
