/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
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

        return dir
            .map{url in return url.appendingPathComponent(file)}
            .map{url -> String in
                do {
                    return try String(contentsOf: url, encoding: .utf8)
                } catch {
                    let newIdentifier = UUID().uuidString
                    do {
                        try newIdentifier.write(to: url, atomically: false, encoding: .utf8)
                    } catch {}
                    return newIdentifier
                }
            } ?? UUID().uuidString
    }
    
    internal static var identifierInfoVendor : String? {
        
        return UIDevice.current.identifierForVendor?.uuidString
    }
}
