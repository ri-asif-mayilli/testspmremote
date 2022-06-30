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

    var snippetId:String
    var _location:String
    var token:String
    var diMobileSdkVersion:String
    let sysctlInfo:SysctlDTO
    let jailBreak:JailbreakDTO
    let device:DeviceVarsDTO
    let battery:BatteryDTO
    
    
    let screen:ScreenDTO
    #if !targetEnvironment(macCatalyst)
    let cellular:CellularDTO
    let cellularIOS12:CellularDTOIOS12
    #endif
    let contacts:ContactDTO
    let networkInfo:NetworkInfoDTO
    
    let proximity:ProximityDTO
    let notification:NotificationDTO
 
    let locale:LocaleInfoDTO
    let identifier:IdentifierInfoDTO
    let motion:MotionInfoDTO
    
    
    func collectErrors() -> RSDKCombinedErrorDTO?{
        if !contacts.errors().isEmpty || !sysctlInfo.errors().isEmpty {
           let errorMessages =  (contacts.errors() + sysctlInfo.errors()).reduce(""){acc, error in
                acc + "errorCode:" + "\(RSdkErrorType.contactStore("", "", error)._code)\n" + "errorDescription" + error + "\n" + "errorDescription" + error + "\n" + "=============================\n"
            }
            
            return RSDKCombinedErrorDTO(errors: errorMessages,snippetId: self.snippetId,token: self.token)
        }
        return nil
    }
    
    init(requestInfoManager:RSdkRequestInfoManager, notificationDTO : NotificationDTO, proximityDTO: ProximityDTO, networkInfoDTO:NetworkInfoDTO) {
        self.snippetId = requestInfoManager._snippetId ?? ""
        self.token = requestInfoManager._token ?? ""
        self._location = requestInfoManager.location ?? ""
        self.proximity = proximityDTO
        self.notification = notificationDTO
        self.networkInfo = networkInfoDTO
        self.diMobileSdkVersion = requestInfoManager._diMobileSdkVersion
        
        self.sysctlInfo = SysctlDTO()
        self.jailBreak = JailbreakDTO()
        self.device = DeviceVarsDTO()
        self.battery = BatteryDTO()

        self.screen = ScreenDTO()
        #if !targetEnvironment(macCatalyst)
        self.cellular = CellularDTO()
        self.cellularIOS12 = CellularDTOIOS12()
        #endif
        self.contacts = ContactDTO()
        self.locale = LocaleInfoDTO()
        self.identifier = IdentifierInfoDTO()
        self.motion = MotionInfoDTO()
        
    }
}



internal struct NetworkInfoDTO : Codable {
 
    let ipv6:String?
    let ipv4:String?
    var ssid:String?
    var proxy: ProxyInfoDTO?

    public init(ssid:String?) {
        if (RSdkNetworkInfo.networkInfoIsProxyConnected) {
            self.proxy = ProxyInfoDTO()
        }
        self.ssid = ssid?.djb2hashString.sha256
        self.ipv6 = RSdkNetworkInfo.networkInfoGetWiFiAddressV6?.djb2hashString.sha256
        self.ipv4 = RSdkNetworkInfo.networkInfoGetWiFiAddressV4?.djb2hashString.sha256
    }
}

internal struct ProxyInfoDTO : Codable {
    
    let proxyType:String?
    let proxyHost:String?
    let proxyPort:String?
    
    init(){
        self.proxyType   = RSdkNetworkInfo.networkInfoProxyType
        self.proxyHost   = RSdkNetworkInfo.networkInfoproxyHost
        let port = RSdkNetworkInfo.networkInfoProxyPort
        self.proxyPort = port != nil ? "\(port!)" : nil
    }
}


