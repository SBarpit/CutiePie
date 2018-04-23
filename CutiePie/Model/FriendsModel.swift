//
//  FriendsModel.swift
//  FriendsModule
//
//  Created by Appinventiv on 11/10/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation
import SwiftyJSON

struct FriendsModel {

    let userId : String
    var name : String

    
    init(withJSON json : JSON){
        
        self.userId = json["user_id"].stringValue
        self.name = json["name"].stringValue
    }
    
}

//MARK:- Response
//===============
//name = "Gurdeep Singh";
//status = 1;
//"user_id" = 13;

