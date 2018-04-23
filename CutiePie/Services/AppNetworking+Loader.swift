//
//  AppNetworking+Loader.swift
//  StarterProj
//
//  Created by Gurdeep on 06/03/17.
//  Copyright © 2017 Gurdeep. All rights reserved.
//

import Foundation
import UIKit
import KVNProgress

extension AppNetworking {
    
    static func showLoader() {
        let conf = KVNProgressConfiguration.default()
        conf?.isFullScreen = false
        KVNProgress.setConfiguration(conf)
        KVNProgress.show()
    }
    
    static func hideLoader() {
        KVNProgress.dismiss()
    }
}

