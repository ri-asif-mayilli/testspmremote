//
//  Device.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 11.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation

struct DeviceDTO : Codable {

    let SysctlInfo = SysctlDTO()
    let JailBreak  = JailbreakDTO()
    let Device     = DeviceVarsDTO()
    let Battery    = BatteryDTO()
    let Screen     = ScreenDTO()
    let Cellular   = CellularDTO()
    let Contacts    = ContactDTO()
    let NetworkInfo  = NetworkInfoDTO()
    
    let Proximity  : ProximityDTO
    let Notification : NotificationDTO
 
    init(notificationDTO : NotificationDTO, proximityDTO: ProximityDTO) {
        
        self.Proximity  = proximityDTO
        self.Notification = notificationDTO        
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
    
    let accesTechnology    = CellularInfo.currentAccessTechnology
    let Carrier = CarrierDTO()
}

struct CarrierDTO : Codable {
    
    let name = CarrierInfo.name
    let countryCode = CarrierInfo.countryCode
    let mobileCountryCode = CarrierInfo.countryCode
    let mobileNetworkCode = CarrierInfo.networkCode
    let isoCoutryCode     = CarrierInfo.isoCountryCode
    let allowsVoip        = CarrierInfo.allowsVoip
    
}

struct SysctlDTO : Codable {
    
    var hostname    : String = SyctlInfoType.hostname.value
    var machine     : String = SyctlInfoType.machine.value
    var activeCPUS  : String = SyctlInfoType.activeCPUs.value
    var osRelease   : String = SyctlInfoType.osRelease.value
    var osRev       : String = SyctlInfoType.osRev.value
    var osType      : String = SyctlInfoType.osType.value
    var osVersion   : String = SyctlInfoType.osVersion.value
    var version     : String = SyctlInfoType.version.value
    var memSize     : String = SyctlInfoType.memSize.value
    var machineArch : String = SyctlInfoType.machineArch.value
}


struct JailbreakDTO : Codable {
    
    var appID           : String?
    var created         : Date?
    var jailBroken      = Jailbreak.isJailbroken
    let existingPaths   = Jailbreak.existingPath
    let cydiaInstalled  = Jailbreak.cydiaInstalled
    let sandboxBreakOut = Jailbreak.sandboxBreak
    
    internal init() {
        
    }
    
    internal init(appID : String, created: Date, existingPaths: [String]) {

        self.appID = appID
        self.created = created
    }
}

struct ContactDTO : Codable {
    
    let access      = ContactInfo.access
    let container   : [ContactStoreDTO]?
    
    public init() {
        
        container = ContactInfo.conctactStores
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
 
    var ip = NetworkInfo.getWiFiAddress
    var ssid = NetworkInfo.getWiFiSsid
}


