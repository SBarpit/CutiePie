//
//  Webservice+EndPoints.swift
//  StarterProj
//
//  Created by Gurdeep on 06/03/17.
//  Copyright © 2017 Gurdeep. All rights reserved.
//

import Foundation


let TIME_OUT_INTERVAL_UPLOAD:Float = 30.0
let TIME_OUT_INTERVAL:Float = 20.0


//enum URLType  : String {
//
//    case url = "https://devrightnow.applaurels.com"
//   //  staging = "https://devrightnow.applaurels.com"
//
//stagingrightnow. devrightnow
//}

//let BASE_URL = "https://stagingrightnow.applaurels.com/api/"
let BASE_URL = "https://devrightnow.applaurels.com/api/"
//let BASE_URL = "http://34.201.229.239/api/"


extension WebServices {
    
    enum EndPoint : String {
        
        //  https://devrightnow.applaurels.com/api/Mapsearch/search_map"
        
        
        case simpleSignUp = "signup"
        case checkemail = "check_email"
        
   
        
        var path : String {
            
            return BASE_URL + self.rawValue
        }
    }
}
