//
//  Webservices.swift
//  StarterProj
//
//  Created by Gurdeep on 16/12/16.
//  Copyright © 2016 Gurdeep. All rights reserved.
//

import Foundation
import SwiftyJSON

enum WebServices { }
var api_key : [String : String]{
    let dict:[String:String] = ["Authorization":"Basic SGFuZG5Gb290OkhhbmQjJCVGb290KiYmUHJpbnQ="]
    return dict
}

extension NSError {
    
    convenience init(localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError", code: 0, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    convenience init(code : Int, localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError", code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
}

extension WebServices {
    
    static func checkEmail(parameters:JSONDictionary,success: @escaping (Bool) -> (),failure: @escaping (Bool) -> ()) {
        
        AppNetworking.GET(endPoint: .checkemail, parameters: parameters, headers: api_key, loader: false, success: { (JSON) in
            success(true)
        }) { (Error) in
            failure(false)
        }
    }
    
    static func signUpAPI(parameters : JSONDictionary, success : @escaping UserControllerSuccess, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        AppNetworking.POST(endPoint: .simpleSignUp, parameters: parameters, headers: api_key, loader: true, success: { (json) in
            if let errorCode = json["CODE"].int, errorCode == error_codes.success {
                
                if let result = json["RESULT"].dictionary {
                    
                    if let rspMsg = json["MESSAGE"].string {
                        
                        let userInfo = User(dictionary: result)
                        userInfo.responseString = rspMsg
                        success(userInfo)
                        
                    }
                    
                    if let access_token = result["accesstoken"]?.string {
                        AppUserDefaults.save(value: access_token, forKey: .Accesstoken)
                    }
                }
                
            } else {
                
                let errorCode = json["CODE"]
                let  errorMsg = json["MESSAGE"]
                
                let error = NSError(code: errorCode.intValue, localizedDescription: errorMsg.stringValue)
                failure(error)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    
    static func loginAPI(parameters : JSONDictionary, success : @escaping UserControllerSuccess, failure : @escaping FailureResponse) {
        
        // Configure Parameters and Headers
        AppNetworking.POST(endPoint: .simpleSignUp, parameters: parameters, loader: true, success: { (json) -> () in
            
            
            if let errorCode = json["CODE"].int, errorCode == error_codes.success {
                
                if let result = json["RESULT"].dictionary {
                    
                    if let resultDictionary = json["RESULT"].dictionaryObject {
                        
                        AppUserDefaults.save(value: resultDictionary, forKey: .userData)
                        
                    }
                    
                    if let rspMsg = json["MESSAGE"].string {
                        
                        let userInfo = User(dictionary: result)
                        userInfo.responseString = rspMsg
                        success(userInfo)
                        
                    }
                    
                    if let access_token = result["accesstoken"]?.string {
                        AppUserDefaults.save(value: access_token, forKey: .Accesstoken)
                    }
                }
                
            } else {
                
                let errorCode = json["CODE"]
                let  errorMsg = json["MESSAGE"]
                
                let error = NSError(code: errorCode.intValue, localizedDescription: errorMsg.stringValue)
                failure(error)
            }
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }
    
    
    static func changePasswordAPI(parameters : ChangePasswordData, success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        // Configure Parameters and Headers
        
        let params = ["password" : parameters.newPassword,
                      "oldpassword" : parameters.oldPassword,
                      "accesstoken" : AppUserDefaults.value(forKey: .Accesstoken).stringValue]
        
        AppNetworking.POST(endPoint: .checkemail, parameters: params, loader: true, success: { (json : JSON) -> Void in
            guard let _ = json.dictionary else {
                
                let e = NSError(localizedDescription: "")
                
                // check error code and present respective error message from here only
                
                failure(e)
                
                return
            }
            
            success(json)
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }
    static func forgotPasswordAPI(email : String, success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        // Configure Parameters and Headers
        
        let params = ["email" : email]
        
        AppNetworking.POST(endPoint: .checkemail, parameters: params, loader: true, success: { (json : JSON) -> Void in
            guard let _ = json.dictionary else {
                
                let e = NSError(localizedDescription: "")
                
                // check error code and present respective error message from here only
                
                failure(e)
                
                return
            }
            
            success(json)
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }
    static func resetPasswordAPI(parameters : JSONDictionary, success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        // Configure Parameters and Headers
        
        AppNetworking.POST(endPoint: .checkemail, parameters: parameters, loader: true, success: { (json : JSON) -> Void in
            guard let _ = json.dictionary else {
                
                let e = NSError(localizedDescription: "")
                
                // check error code and present respective error message from here only
                
                failure(e)
                
                return
            }
            
            success(json)
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }
    static func profileAPI(success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        // Configure Parameters and Headers
        
        AppNetworking.GET(endPoint: .simpleSignUp, parameters: [:], loader: true, success: { (json : JSON) -> Void in
            guard let _ = json.dictionary else {
                
                let e = NSError(localizedDescription: "")
                
                // check error code and present respective error message from here only
                
                failure(e)
                
                return
            }
            
            success(json)
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }
    
    static func getUserList(parameters : JSONDictionary,success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        // Configure Parameters and Headers
        
        AppNetworking.GET(endPoint: .simpleSignUp, parameters: parameters, loader: false, success: { (json : JSON) -> Void in
            guard let _ = json.dictionary else {
                
                let e = NSError(localizedDescription: "")
                
                // check error code and present respective error message from here only
                
                failure(e)
                
                return
            }
            
            success(json)
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }
    
    static func logoutAPI(success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        // Configure Parameters and Headers
        
        var parameters : [String:Any] = [:]
        
        if AppUserDefaults.value(forKey: .Accesstoken) != JSON.null {
            
            parameters["accesstoken"] = AppUserDefaults.value(forKey: .Accesstoken).stringValue
            
        }
        
        AppNetworking.PUT(endPoint: .simpleSignUp, parameters: parameters, loader: true, success: { (json : JSON) -> Void in
            guard let _ = json.dictionary else {
                
                let e = NSError(localizedDescription: "")
                
                // check error code and present respective error message from here only
                
                failure(e)
                
                return
            }
            
            success(json)
        }, failure: { (e : Error) -> Void in
            failure(e)
        })
    }
}

//MARK:- Error Codes
//==================
struct error_codes {
    static let success = 200
    
}

