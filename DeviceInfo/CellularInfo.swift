//
//  CellularInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 11.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

//        _CTServerConnectionCopyWakeReason
//        _CTServerConnectionCopyVoiceMailInfo

//        As of iOS 8.3 all of the above solutions require entitlement to work


//        <key>com.apple.CommCenter.fine-grained</key>
//        <array>
//        <string>spi</string>
//        </array>

//        Not only cell monitor is protected but it seems like all of the CoreTelephony notifications now require that entitlement to work. For example, kCTMessageReceivedNotification also affected.


import Foundation
import CoreTelephony

struct CellularInfo {
    
    internal static var currentAccessTechnology : String? {
    
        if #available(iOS 9, *) {
            return CTTelephonyNetworkInfo().currentRadioAccessTechnology
        }
        return nil
    }
}

struct CarrierInfo {
    
    static private var carrier : CTCarrier? {
        
        return CTTelephonyNetworkInfo().subscriberCellularProvider
    }
    
    static internal var name : String? {
        
        return carrier?.carrierName
    }
    
    static internal var countryCode : String? {
    
        return carrier?.mobileCountryCode
    }
    
    static internal var networkCode : String? {
    
        return carrier?.mobileNetworkCode
    }
    
    static internal var isoCountryCode : String? {
        
        return carrier?.isoCountryCode
    }
    
    static internal var allowsVoip : Bool? {
        
        return carrier?.allowsVOIP
    }
}
