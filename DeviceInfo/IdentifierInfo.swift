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
    
    internal static var identifierUniqueAppIdentifier : String? {
        return nil
    }
    
    internal static var identifierlocalStorage : String {
        let file = "identifier"
        let fileManager = FileManager.default
        
        let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        if(dir == nil) {
            return UUID().uuidString
        }
        let fileURL = dir!.appendingPathComponent(file)
        do {
            let identifier = try String(contentsOf: fileURL, encoding: .utf8)
            return identifier
        } catch{
            let newIdentifier = UUID().uuidString
            do {
                try newIdentifier.write(to: fileURL, atomically: false, encoding: .utf8)
                return newIdentifier
            } catch {
                return newIdentifier
            }
        }
    }
    
    internal static var identifierInfoVendor : String? {
        
        return UIDevice.current.identifierForVendor?.uuidString
    }
}
