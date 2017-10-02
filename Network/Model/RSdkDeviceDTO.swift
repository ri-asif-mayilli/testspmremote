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

    var snippetId    : String
    var location     : String
    var requestToken : String
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
        self.requestToken   = requestToken
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
    
    let name            = DeviceInfo.name
    let model           = DeviceInfo.model
    let localizedModel  = DeviceInfo.localizedModel
    let systemName      = DeviceInfo.systemName
    let systemVersion   = DeviceInfo.systemVersion
    let orientationNotifaction = DeviceInfo.orientationNotifaction
    let deviceOrientation = DeviceInfo.deviceOrientation
    let multitasking    = DeviceInfo.multitaskingSupported
    let isSimulator     = DeviceInfo.isSimulator
}

struct BatteryDTO  : Codable {

    let batteryMonitoringEnabled = Battery.monitoringEnabled
    let batteryState    = Battery.state
    let batteryLevel    = Battery.level
}

struct ProximityDTO : Codable {
    
    let monitoringEnabled = Proximity.monitoringEnabled
    let state             : Bool
    
    init(state : Bool) {
        
        self.state = state
    }
}

struct ScreenDTO : Codable {
    
    let idiom   = Display.userInterfaceIdiom
    let interfaceLayout = Display.userInterfaceLayout
    let Bounds  = ScreenBoundDTO()
    let Size    = ScreenSizeDTO()
}

struct ScreenBoundDTO : Codable {
    
    let minX    = Display.screenBoundMinX
    let maxX    = Display.screenBoundMaxX
    let minY    = Display.screenBoundMinY
    let maxY    = Display.screenBoundMaxX
    let height  = Display.screenBoundHeight
    let width   = Display.screenBoundWidth
}

struct ScreenSizeDTO : Codable {
    
    let height = Display.screenSizeHeight
    let widt   = Display.screenBoundWidth
}

struct CellularDTO : Codable {
    
    let accesTechnologe = CellularInfo.currentAccessTechnology
    let carrier = CarrierDTO()
}

struct CarrierDTO : Codable {
    
    let name              = CarrierInfo.name
    let countryCode       = CarrierInfo.countryCode
    let mobileCountryCode = CarrierInfo.countryCode
    let mobileNetworkCode = CarrierInfo.networkCode
    let isoCoutryCode     = CarrierInfo.isoCountryCode
    let allowsVoip        = CarrierInfo.allowsVoip
    
}

struct SysctlDTO : Codable {
    
    var hostname    = RSdkSyctlInfoType.hostname.value.djb2hash
    var machine     = RSdkSyctlInfoType.machine.value
    var activeCPUS  = RSdkSyctlInfoType.activeCPUs.value
    var osRelease   = RSdkSyctlInfoType.osRelease.value
    var osRev       = RSdkSyctlInfoType.osRev.value
    var osType      = RSdkSyctlInfoType.osType.value
    var osVersion   = RSdkSyctlInfoType.osVersion.value
    var version     = RSdkSyctlInfoType.version.value
    var memSize     = RSdkSyctlInfoType.memSize.value
    var machineArch = RSdkSyctlInfoType.machineArch.value
}


struct JailbreakDTO : Codable {
    
    var appId           : String?
    var created         : Date?
    var jailBroken      = RSdkJailbreak.isJailbroken
    let existingPaths   = RSdkJailbreak.existingPath
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
    
    let access      = RSdkContactInfo.access
    let container   : [ContactStoreDTO]?
    
    public init() {
        
        container = RSdkContactInfo.conctactStores
    }
}

struct ContactStoreDTO : Codable {
    
    let identifier : String
    let name : String
    let type : String
    let contacts : Int
    
    public init(_ identifier: String, name: String, type: String, count: Int) {
        
        self.identifier = identifier
        self.name = name
        self.type = type
        self.contacts = count
    }
}

struct NetworkInfoDTO : Codable {
 
    let ip = NetworkInfo.getWiFiAddress
    let ssid = NetworkInfo.getWiFiSsid?.djb2hash
    let proxyConnected = ProxyInfoDTO()
}

struct ProxyInfoDTO : Codable {
    
    let isConnected = NetworkInfo.isProxyConnected
    let proxyType   = NetworkInfo.proxyType
    let proxyHost   = NetworkInfo.proxyHost
    let proxyPort   = NetworkInfo.proxyPort
}

struct LocaleInfoDTO : Codable {
    
    let preferedlanguages = LocaleInfo.preferedLanguages
    let timeZone = LocaleInfo.localTimeZone
}

struct IdentifierInfoDTO : Codable {
    
    let vendorId              = IdentifierInfo.vendor
    let advertTrackingEnabled = IdentifierInfo.isAdvertisingEnabled
    let advertTrackingId      = IdentifierInfo.advertising
}

struct MotionInfoDTO : Codable {
    
    let accelerometerAvailable = MotionInfo.accelerometerAvailable
    let deviceMotionAvailable = MotionInfo.deviceMotionAvailable
    let magnetometerAvailable = MotionInfo.magnetometerAvailable
    let gyroAvailable = MotionInfo.gyroAvailable
}
