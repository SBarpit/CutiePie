//
//  AppNetworking.swift
//  StarterProj
//
//  Created by Gurdeep on 16/12/16.
//  Copyright © 2016 Gurdeep. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

typealias JSONDictionary = [String : Any]
typealias JSONDictionaryArray = [JSONDictionary]
typealias SuccessResponse = (_ json : JSON) -> ()
typealias FailureResponse = (Error) -> (Void)
typealias UserControllerSuccess = (_ user : User) -> ()


extension Notification.Name {
    
    static let NotConnectedToInternet = Notification.Name("NotConnectedToInternet")
}

enum AppNetworking {
    
//    static let USER = "admin"
//    static let PASSWORD = "mypass"
//    static let REALM = "8AC74BD0018D507238924D65D0184E93"
//    static let NONCE = "12345"
//    static let QOP = "auth"
//    static let NONCE_COUNT = "12345"
//    static let CNONCE = "123"

    static let username = "admin"
    static let password = "12345"
    
    static func POST(endPoint : WebServices.EndPoint,
                     parameters : JSONDictionary = [:],
                     headers : HTTPHeaders = [:],
                     loader : Bool = true,
                     success : @escaping (JSON) -> Void,
                     failure : @escaping (Error) -> Void) {
        
        
        request(URLString: endPoint.path, httpMethod: .post, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func POSTWithImage(endPoint : WebServices.EndPoint,
                              parameters : [String : Any] = [:],
                              image : [String:UIImage]? = [:],
                              headers : HTTPHeaders = [:],
                              loader : Bool = true,
                              success : @escaping (JSON) -> Void,
                              failure : @escaping (Error) -> Void) {
        
        upload(URLString: endPoint.path, httpMethod: .post, parameters: parameters,image: image ,headers: headers, loader: loader, success: success, failure: failure )
    }
    
    static func GET(endPoint : WebServices.EndPoint,
                    parameters : JSONDictionary = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path, httpMethod: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func PUT(endPoint : WebServices.EndPoint,
                    parameters : JSONDictionary = [:],
                    headers : HTTPHeaders = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path, httpMethod: .put, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func DELETE(endPoint : WebServices.EndPoint,
                       parameters : JSONDictionary = [:],
                       headers : HTTPHeaders = [:],
                       loader : Bool = true,
                       success : @escaping (JSON) -> Void,
                       failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint.path, httpMethod: .delete, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    private static func request(URLString : String,
                                httpMethod : HTTPMethod,
                                parameters : JSONDictionary = [:],
                                encoding: URLEncoding = .httpBody,
                                headers : HTTPHeaders = [:],
                                loader : Bool = true,
                                success : @escaping (JSON) -> Void,
                                failure : @escaping (Error) -> Void) {
        
                if loader { showLoader() }
//        let uri = URLString.replacingOccurrences(of: BASE_URL, with: "")
//
//        let digestHeader = getDigestHeader(method: httpMethod.rawValue, uri: uri)
        
        guard let data = "\(username):\(password)".data(using: String.Encoding.utf8) else { return  }
        
        let base64 = data.base64EncodedString()

        
        var header : HTTPHeaders = ["Authorization" : "Basic \(base64)",
                                    "content-type": "application/x-www-form-urlencoded"]
        if AppUserDefaults.value(forKey: .Accesstoken) != JSON.null {
            
            header["Accesstoken"] = AppUserDefaults.value(forKey: .Accesstoken).stringValue
            
        }
        
        let request = Alamofire.request(URLString,
                          method: httpMethod,
                          parameters: parameters,
                          encoding: encoding,
                          headers: header)

        request.responseString { (data) in
            print(data)
        }

        request.responseJSON { (response:DataResponse<Any>) in
                            
                            //                        print_debug(headers)
                            
                                        if loader { hideLoader() }
                            
                            switch(response.result) {
                                
                            case .success(let value):
                                
                                print_debug(value)
                                
                                success(JSON(value))
                                
                            case .failure(let e):
                                
                                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                    
                                    // Handle Internet Not available UI
                                    if loader { hideLoader() }

                                    NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                                }
                                
                                failure(e)
                            }
        }
    }
    
    
    private static func upload(URLString : String,
                               httpMethod : HTTPMethod,
                               parameters : JSONDictionary = [:],
                               image : [String:UIImage]? = [:],
                               headers : HTTPHeaders = [:],
                               loader : Bool = true,
                               success : @escaping (JSON) -> Void,
                               failure : @escaping (Error) -> Void) {
        
                if loader { showLoader() }
//
//        let uri = URLString.replacingOccurrences(of: BASE_URL, with: "")
//
//        let digestHeader = getDigestHeader(method: httpMethod.rawValue, uri: uri)
        
        guard let data = "\(username):\(password)".data(using: String.Encoding.utf8) else { return  }
        
        let base64 = data.base64EncodedString()
        
        
        var header : HTTPHeaders = ["Authorization" : "Basic \(base64)",
                                    "content-type": "application/x-www-form-urlencoded"]
        if AppUserDefaults.value(forKey: .Accesstoken) != JSON.null {
            
            header["Accesstoken"] = AppUserDefaults.value(forKey: .Accesstoken).stringValue
            
        }

        let url = try! URLRequest(url: URLString, method: httpMethod, headers: header)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let image = image {
                for (key , value) in image{
                    //                    print_debug("key = \(key) value = \(value)")
                    if let img = UIImageJPEGRepresentation(value, 0.6){
                        //                        print_debug(img)
                        multipartFormData.append(img, withName: key, fileName: "image.jpg", mimeType: "image/jpg")
                    }
                }
            }
            
            for (key , value) in parameters{
                
                multipartFormData.append((value as AnyObject).data(using : String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
                         with: url, encodingCompletion: { encodingResult in
                            
                            switch encodingResult{
                            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                                
                                upload.responseJSON(completionHandler: { (response:DataResponse<Any>) in
                                    switch response.result{
                                    case .success(let value):
                                                                                if loader { hideLoader() }
                                        
                                        
                                        print_debug(value)
                                        success(JSON(value))
                                        
                                    case .failure(let e):
                                                                                if loader { hideLoader() }
                                        
                                        
                                        if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                            NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                                        }
                                        failure(e)
                                    }
                                })
                                
                            case .failure(let e):
                                //                if loader { hideLoader() }
                                
                                
                                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                                    NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                                }
                                
                                failure(e)
                            }
        })
        
    }
    
//    private static func getDigestHeader(method : String, uri : String) -> String
//    {
//        
//        let a1 = getMD5Hex(md5Data: MD5(string: (USER + ":" + REALM + ":" + PASSWORD)))
//        let a2 = getMD5Hex(md5Data: MD5(string: (method + ":" + uri)))
//        let response = getMD5Hex(md5Data: MD5(string: (a1 + ":" + NONCE + ":" + NONCE_COUNT + ":" + CNONCE + ":" + QOP + ":" + a2)))
//        
//        let digestHeader = "Digest username=\"\(USER)\", realm=\"\(REALM)\", nonce=\"\(NONCE)\", uri=\"\(uri)\", qop=\(QOP), nc=\(NONCE_COUNT), cnonce=\"\(CNONCE)\", response=\"\(response)\", opaque=\"\(12)\""
//        
//        return digestHeader
//    }
//    
//    private static func MD5(string: String) -> Data? {
//        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
//        var digestData = Data(count: Int(16))
//        
//        _ = digestData.withUnsafeMutableBytes {digestBytes in
//            messageData.withUnsafeBytes {messageBytes in
//                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
//            }
//        }
//        
//        return digestData
//    }
//    
//    private static func getMD5Hex(md5Data : Data?) -> String
//    {
//        if md5Data == nil
//        {
//            return ""
//        }
//        
//        return md5Data!.map { String(format: "%02hhx", $0) }.joined()
//    }
}




