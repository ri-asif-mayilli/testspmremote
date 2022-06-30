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
        if #available(iOS 12.0, *){
            return nil
        }else if #available(iOS 9, *) {
            return CTTelephonyNetworkInfo().currentRadioAccessTechnology
        }

        return nil
    }
}


internal struct RSdkCarrierInfo {
    
    
    static private var carrierInfoCarrier : CTCarrier? {
        
        if #available(iOS 12.0, *){
            return nil
        }else if #available(iOS 9, *) {
            return CTTelephonyNetworkInfo().subscriberCellularProvider
        }

        return nil

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

internal struct RSdkCellularInfoIOS12 {
    internal static var celluarInfoCurrentAccessTechnology : [String]? {
        if #available(iOS 12, *) {
            guard let accessTech = CTTelephonyNetworkInfo().serviceCurrentRadioAccessTechnology else {return nil}
            let result = accessTech.keys.compactMap{accessTech[$0]}
            if !result.isEmpty{ return result}
        }
        return nil
    }
}

internal struct RSdkCarrierInfoIOS12 {
    static private var carrierInfoCarrier : [String:CTCarrier]? {
        if #available(iOS 12.0, *) {
            return CTTelephonyNetworkInfo().serviceSubscriberCellularProviders
        }
        return nil
    }
    
    static internal var carrierInfoName : [String]? {
        guard let carrierInfo = carrierInfoCarrier else {return nil}
        let result = carrierInfo.keys.compactMap{carrierInfo[$0]?.carrierName}

        if result.isEmpty{return nil} else {return result}
    }
    
    static internal var carrierInfoCountryCode : [String]? {
        guard let carrierInfo = carrierInfoCarrier else {return nil}
        let result = carrierInfo.keys.compactMap{carrierInfo[$0]?.mobileCountryCode}
        
        if result.isEmpty{return nil} else {return result}
    }
    
    static internal var carrierInfoNetworkCode : [String]? {
        guard let carrierInfo = carrierInfoCarrier else {return nil}
        let result = carrierInfo.keys.compactMap{carrierInfo[$0]?.mobileNetworkCode}
        
        if result.isEmpty{return nil} else {return result}
    }
    
    static internal var carrierInfoIsoCountryCode : [String]? {
        guard let carrierInfo = carrierInfoCarrier else {return nil}
        let result = carrierInfo.keys.compactMap{carrierInfo[$0]?.isoCountryCode}
        
        if result.isEmpty{return nil} else {return result}
    }
    
    static internal var carrierInfoAllowsVoip : [Bool]? {
        guard let carrierInfo = carrierInfoCarrier else {return nil}
        let result = carrierInfo.keys.compactMap{carrierInfo[$0]?.allowsVOIP}
       
        if result.isEmpty{return nil} else {return result}
    }
}
#endif
