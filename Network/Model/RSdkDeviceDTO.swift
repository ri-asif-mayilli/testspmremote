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
    
    
    func collectErrors() -> RSDKNewErrorDTO?{
        if !contacts.errors().isEmpty || !sysctlInfo.errors().isEmpty {
            var errorMesages = ""
            for item in (contacts.errors() + sysctlInfo.errors()){
                errorMesages = errorMesages + "errorCode:" + "\(RSdkErrorType.contactStore("", "", item)._code)\n"
                errorMesages = errorMesages + "errorDescription" + item + "\n"
                errorMesages = errorMesages +  "=============================\n"
            }
            return RSDKNewErrorDTO(errors: errorMesages,snippetId: self.snippetId,token: self.token)
          //  return RSDKNewErrorDTO(
        }
        return nil
    }
    
    init(_ snippetId: String, requestToken: String, _location: String, mobileSdkVersion: String, notificationDTO : NotificationDTO, proximityDTO: ProximityDTO) {
        
        self.snippetId      = snippetId
        self.token          = requestToken
        self._location       = _location
        self.proximity      = proximityDTO
        self.notification   = notificationDTO
        self.diMobileSdkVersion = mobileSdkVersion
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






