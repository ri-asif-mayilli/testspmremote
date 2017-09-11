//
//  Device.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 11.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation

struct DataModel : Codable {
    
    let sysctlInfo      = SysctlInfo()
//    var jailBreakInfo   = JailBreakInfo()
}

struct Device : Codable {
    
}

enum SyctlInfoType {
    
    case hostname
    case machine
    case model
    case activeCPUs
    case osRelease
    case osRev
    case osType
    case osVersion
    case version
    case memSize
    case machineArch

    var value : String {
        
        switch(self) {
            case .machineArch:
            return Sysctl.machineArch
            
            case .hostname:
            return Sysctl.hostName
            
            case .machine:
            return Sysctl.machine
            
            case .model:
            return Sysctl.model
            
            case .activeCPUs:
            return String(describing: Sysctl.activeCPUs)
            
            case .osRelease:
            return Sysctl.osRelease
            
            case .osRev:
            return String(describing: Sysctl.kernID)
            
            case .osType:
            return Sysctl.osType
            
            case .osVersion:
            return Sysctl.osVersion
            
            case .memSize:
            return Sysctl.memSize.description
            
            case .version:
            return Sysctl.version
        }
    }
}

struct SysctlInfo : Codable {
    
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


struct JailBreakInfo : Codable {
    
    var appID           : String?
    var created         : Date?
    var jailBroken      = Jailbreak.isJailbroken
    let existingPaths   = Jailbreak.existingPath
    let cydiaInstalled  = Jailbreak.cydiaInstalled
//    let sandboxBreakOut = Jailbreak.sandboxWrite
    
    public init(appID : String, created: Date, existingPaths: [String]) {

        self.appID = appID
        self.created = created
    }
}


