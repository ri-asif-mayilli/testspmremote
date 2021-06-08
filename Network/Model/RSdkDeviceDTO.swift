/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
//
//  Device.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 11.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import MapKit

struct RSdkDeviceDTO : Codable {

    var snippetId  : String
    var _location   : String
    var token      : String
    var diMobileSdkVersion : String
    let sysctlInfo = SysctlDTO()
    let jailBreak  = JailbreakDTO()
    let device     = DeviceVarsDTO()
    let battery    = BatteryDTO()
    
    
    let screen     = ScreenDTO()
    #if !targetEnvironment(macCatalyst)
    let cellular   = CellularDTO()
    #endif
    let contacts    = ContactDTO()
    let networkInfo  = NetworkInfoDTO()
    
    let proximity  : ProximityDTO
    let notification : NotificationDTO
 
    let locale = LocaleInfoDTO()
    let identifier = IdentifierInfoDTO()
    let motion = MotionInfoDTO()
    
    init(_ snippetId: String, requestToken: String, _location: String, mobileSdkVersion: String, notificationDTO : NotificationDTO, proximityDTO: ProximityDTO) {
        
        self.snippetId      = snippetId
        self.token          = requestToken
        self._location       = _location
        self.proximity      = proximityDTO
        self.notification   = notificationDTO
        self.diMobileSdkVersion = mobileSdkVersion
    }
}

struct NotificationDTO : Codable {
    
    let enabled : Bool
    
    init(enabled: Bool) {
        
        self.enabled = enabled
    }
}


struct ProximityDTO : Codable {
    
    let monitoringEnabled = RSdkProximity.rsdkProximityMonitoringEnabled
    let state             : Bool
    
    init(state : Bool) {
        
        self.state = state
    }
}


#if !targetEnvironment(macCatalyst)
struct CellularDTO : Codable {
    
    let accessTechnology = RSdkCellularInfo.celluarInfoCurrentAccessTechnology
    let carrier = CarrierDTO()
}


struct CarrierDTO : Codable {
    
    let name              = RSdkCarrierInfo.carrierInfoName
    let countryCode       = RSdkCarrierInfo.carrierInfoCountryCode
    let mobileCountryCode = RSdkCarrierInfo.carrierInfoCountryCode
    let mobileNetworkCode = RSdkCarrierInfo.carrierInfoNetworkCode
    let isoCountryCode    = RSdkCarrierInfo.carrierInfoIsoCountryCode
    let allowsVoip        = RSdkCarrierInfo.carrierInfoAllowsVoip
    
}
#endif





struct ContactStoreDTO : Codable {
    
    let identifier : String
    let name : String
    let contactType : String
    let count : Int
    
    public init(_ identifier: String, name: String, type: String, count: Int) {
        
        self.identifier = identifier
        self.name = name
        self.contactType = type
        self.count = count
    }
}

extension ContactStoreDTO: Equatable {
    public static func ==(lhs: ContactStoreDTO, rhs: ContactStoreDTO) -> Bool {
        return
            lhs.identifier == rhs.identifier &&
            lhs.name == rhs.name &&
            lhs.contactType == rhs.contactType &&
            lhs.count == rhs.count     
    }
}


internal struct NetworkInfoDTO : Codable {
 
    let ipv6 = RSdkNetworkInfo.networkInfoGetWiFiAddressV6?.djb2hashString.sha256
    let ipv4 = RSdkNetworkInfo.networkInfoGetWiFiAddressV4?.djb2hashString.sha256
    
    var ssid = RSdkNetworkInfo.networkInfoGetWiFiSsid?.djb2hashString.sha256
    var proxy: ProxyInfoDTO?

    public init() {
        if (RSdkNetworkInfo.networkInfoIsProxyConnected) {
            self.proxy = ProxyInfoDTO()
        }
    }
}

internal struct ProxyInfoDTO : Codable {
    
    let proxyType   = RSdkNetworkInfo.networkInfoProxyType
    let proxyHost   = RSdkNetworkInfo.networkInfoproxyHost
    let proxyPort   = RSdkNetworkInfo.networkInfoProxyPort
}

internal struct LocaleInfoDTO : Codable {
    
    let preferredLanguages = RSdkLocaleInfo.localeInfoPreferredLanguages
    let timeZone = RSdkLocaleInfo.localeInfoLocalTimeZone
}





internal struct MotionInfoDTO : Codable {
    
    let accelerometerAvailable  = RSdkMotionInfo.motionInfoAccelerometerAvailable
    let deviceMotionAvailable   = RSdkMotionInfo.motionInfoDeviceMotionAvailable
    let magnetometerAvailable   = RSdkMotionInfo.motionInfoMagnetometerAvailable
    let gyroAvailable           = RSdkMotionInfo.motionInfoGyroAvailable
}
