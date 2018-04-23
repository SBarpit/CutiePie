//
//  Globals.swift
//  Onboarding
//
//  Created by Appinventiv on 22/08/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import Foundation
import UIKit

let sharedAppDelegate = UIApplication.shared.delegate as! AppDelegate

func print_debug <T> (_ object: T) {
    
    // TODO: Comment Next Statement To Deactivate Logs
    print(object)
    
}

var isSimulatorDevice:Bool {
    
    var isSimulator = false
    #if arch(i386) || arch(x86_64)
        //simulator
        isSimulator = true
    #endif
    return isSimulator
}
