//
//  IdentifierInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 18.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import UIKit
import AdSupport

struct RSdkIdentifierInfo {
    
    internal static var identifierInfoIsAdvertisingEnabled : Bool {
        
        return ASIdentifierManager.shared().isAdvertisingTrackingEnabled
    }
    
    internal static var identifierInfoAdvertising : String {
        
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    internal static var identifierUniqueAppIdentifier : String {
        
        if let appIdData = RSdkKeyChainService.loadFromChain(fromType: .uniqueAppID), let appId = String(data: appIdData, encoding: .utf8) {
            
            return  appId
        }
        let appId = UUID().uuidString
        if let data = appId.data(using: .utf8) {
            
            let result = RSdkKeyChainService.saveToChain(forType: .uniqueAppID, data: data)
            switch(result) {
                
                default:
                break
            }
        }
        return appId
    }
    
    internal static var identifierInfoVendor : String? {
        
        return UIDevice.current.identifierForVendor?.uuidString
    }
}
