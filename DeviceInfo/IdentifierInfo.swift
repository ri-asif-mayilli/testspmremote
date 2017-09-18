//
//  IdentifierInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 18.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import UIKit
import AdSupport

struct IdentifierInfo {
    
    internal static var vendor : String? {
    
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    internal static var isAdvertisingEnabled : Bool {
        
        return ASIdentifierManager.shared().isAdvertisingTrackingEnabled
    }
    
    internal static var advertising : String {
        
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
}
