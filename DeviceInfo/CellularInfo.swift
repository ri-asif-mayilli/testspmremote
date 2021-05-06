/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
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

#if !targetEnvironment(macCatalyst)
import Foundation

import CoreTelephony



internal struct RSdkCellularInfo {
    
    
    
    internal static var celluarInfoCurrentAccessTechnology : String? {
   
        if #available(iOS 9, *) {
            return CTTelephonyNetworkInfo().currentRadioAccessTechnology
        }

        return nil
    }
}


internal struct RSdkCarrierInfo {
    
    
    static private var carrierInfoCarrier : CTCarrier? {
        
        return CTTelephonyNetworkInfo().subscriberCellularProvider
    }

    
    static internal var carrierInfoName : String? {
        
        return carrierInfoCarrier?.carrierName
    }
    
    static internal var carrierInfoCountryCode : String? {
    
        return carrierInfoCarrier?.mobileCountryCode
    }
    
    static internal var carrierInfoNetworkCode : String? {
    
        return carrierInfoCarrier?.mobileNetworkCode
    }
    
    static internal var carrierInfoIsoCountryCode : String? {
        
        return carrierInfoCarrier?.isoCountryCode
    }
    
    static internal var carrierInfoAllowsVoip : Bool? {
        
        return carrierInfoCarrier?.allowsVOIP
    }
}
#endif
