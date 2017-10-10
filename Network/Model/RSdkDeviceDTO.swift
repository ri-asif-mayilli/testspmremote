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
    var location   : String
    var token      : String
    let sysctlInfo = SysctlDTO()
    let jailBreak  = JailbreakDTO()
    let device     = DeviceVarsDTO()
    let battery    = BatteryDTO()
    let screen     = ScreenDTO()
    let cellular   = CellularDTO()
    let contacts    = ContactDTO()
    let networkInfo  = NetworkInfoDTO()
    
    let proximity  : ProximityDTO
    let notification : NotificationDTO
    let locationInfo     : LocationDTO
 
    let locale = LocaleInfoDTO()
    let identifer = IdentifierInfoDTO()
    let motion = MotionInfoDTO()
    
    init(_ snippetId: String, requestToken: String, location: String, geoLocation: CLLocation?, notificationDTO : NotificationDTO, proximityDTO: ProximityDTO) {
        
        self.snippetId      = snippetId
        self.token          = requestToken
        self.location       = location
        self.proximity      = proximityDTO
        self.notification   = notificationDTO
        if let geoLocation = geoLocation {
            
            self.locationInfo = LocationDTO(location: geoLocation)
        } else {
            
            self.locationInfo = LocationDTO()
        }
    }
}

struct NotificationDTO : Codable {
    
    let enabled : Bool
    
    init(enabled: Bool) {
        
        self.enabled = enabled
    }
}

struct DeviceVarsDTO : Codable {
    
    let name            = RSdkDeviceInfo.deviceInfoName
    let model           = RSdkDeviceInfo.deviceInfoModel
    let localizedModel  = RSdkDeviceInfo.deviceInfoLocalizedModel
    let systemName      = RSdkDeviceInfo.deviceInfoSystemName
    let systemVersion   = RSdkDeviceInfo.deviceInfoSystemVersion
    let orientationNotification = RSdkDeviceInfo.deviceInfoOrientationNotifaction
    let deviceOrientation = RSdkDeviceInfo.deviceInfoDeviceOrientation
    let multitasking    = RSdkDeviceInfo.deviceInfoMultitaskingSupported
    let isSimulator     = RSdkDeviceInfo.deviceInfoIsSimulator
}

struct BatteryDTO  : Codable {

    let batteryMonitoringEnabled = RSdkBattery.rsdkMonitoringEnabled
    let batteryState    = RSdkBattery.rsdkBatteryState
    let batteryLevel    = RSdkBattery.rsdkLevel
}

struct ProximityDTO : Codable {
    
    let monitoringEnabled = RSdkProximity.rsdkProximityMonitoringEnabled
    let state             : Bool
    
    init(state : Bool) {
        
        self.state = state
    }
}

struct ScreenDTO : Codable {
    
    let idiom   = RSdkDisplay.rsdkDisplayUserInterfaceIdiom
    let interfaceLayout = RSdkDisplay.rsdkUserInterfaceLayout
    let bounds  = ScreenBoundDTO()
    let size    = ScreenSizeDTO()
}

struct ScreenBoundDTO : Codable {
    
    let minX    = RSdkDisplay.rsdkScreenBoundMinX
    let maxX    = RSdkDisplay.rsdkScreenBoundMaxX
    let minY    = RSdkDisplay.rsdkScreenBoundMinY
    let maxY    = RSdkDisplay.rsdkScreenBoundMaxX
    let height  = RSdkDisplay.rsdkScreenBoundHeight
    let width   = RSdkDisplay.rsdkScreenBoundWidth
}

struct ScreenSizeDTO : Codable {
    
    let height = RSdkDisplay.rsdkScreenSizeHeight
    let width  = RSdkDisplay.rsdkScreenBoundWidth
}

struct CellularDTO : Codable {
    
    let accesTechnologe = RSdkCellularInfo.celluarInfoCurrentAccessTechnology
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

struct SysctlDTO : Codable {
    
    var hostname    = RSdkSyctlInfoType.hostname.sysctlValue.djb2hash
    var machine     = RSdkSyctlInfoType.machine.sysctlValue
    var activeCPUS  = RSdkSyctlInfoType.activeCPUs.sysctlValue
    var osRelease   = RSdkSyctlInfoType.osRelease.sysctlValue
    var osRev       = RSdkSyctlInfoType.osRev.sysctlValue
    var osType      = RSdkSyctlInfoType.osType.sysctlValue
    var osVersion   = RSdkSyctlInfoType.osVersion.sysctlValue
    var version     = RSdkSyctlInfoType.version.sysctlValue
    var memSize     = RSdkSyctlInfoType.memSize.sysctlValue
    var machineArch = RSdkSyctlInfoType.machineArch.sysctlValue
}


struct JailbreakDTO : Codable {
    
    var appId           : String?
    var created         : Date?
    var jailBroken      = RSdkJailbreak.isJailbroken
    let existingPaths   = RSdkJailbreak.jbExistingPath
    let cydiaInstalled  = RSdkJailbreak.cydiaInstalled
    let sandboxBreakOut = RSdkJailbreak.sandboxBreak
    
    internal init() {
        
    }
    
    internal init(appID : String, created: Date, existingPaths: [String]) {

        self.appId = appID
        self.created = created
    }
}

struct ContactDTO : Codable {
    
    let access          = RSdkContactInfo.accessContacts
    let contactsStores  = RSdkContactInfo.conctactStores
}

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

internal struct NetworkInfoDTO : Codable {
 
    let ip = RSdkNetworkInfo.networkInfoGetWiFiAddress
    let ssid = RSdkNetworkInfo.networkInfoGetWiFiSsid?.djb2hash
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

internal struct IdentifierInfoDTO : Codable {
    
    let vendorId              = RSdkIdentifierInfo.identifierInfoVendor
    let advertTrackingEnabled = RSdkIdentifierInfo.identifierInfoIsAdvertisingEnabled
    let advertTrackingId      = RSdkIdentifierInfo.identifierInfoAdvertising
}

internal struct MotionInfoDTO : Codable {
    
    let accelerometerAvailable  = RSdkMotionInfo.motionInfoAccelerometerAvailable
    let deviceMotionAvailable   = RSdkMotionInfo.motionInfoDeviceMotionAvailable
    let magnetometerAvailable   = RSdkMotionInfo.motionInfoMagnetometerAvailable
    let gyroAvailable           = RSdkMotionInfo.motionInfoGyroAvailable
}
