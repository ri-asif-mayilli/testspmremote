//
//  SysctlDTO.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 20.05.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation
struct SysctlDTO : Codable {
    
    let hostname:String
    let machine:String
    let activeCPUs:String
    let osRelease:String
    let osRev:String
    let osType:String
    let osVersion:String
    let version:String
    let machineArch:String
    let memSize:String = RSdkSyctlInfoType.memSize.sysctlValue
    let bootTimestamp:String = RSdkSyctlInfoType.bootTimestamp.sysctlValue
    
    
    
    init(){
        self.hostname = RSdkSyctlInfoType.hostname.sysctlValue.djb2hashString.sha256
        self.machine = RSdkSyctlInfoType.machine.sysctlValue
        self.activeCPUs = RSdkSyctlInfoType.activeCPUs.sysctlValue
        self.osRelease = RSdkSyctlInfoType.osRelease.sysctlValue
        self.osRev = RSdkSyctlInfoType.osRev.sysctlValue
        self.osVersion = RSdkSyctlInfoType.osVersion.sysctlValue
        self.version = RSdkSyctlInfoType.version.sysctlValue
        self.machineArch = RSdkSyctlInfoType.machineArch.sysctlValue
        self.osType = RSdkSyctlInfoType.osType.sysctlValue
    }
    
    init(hostname:String,machine:String,activeCPUs:String,osRelease:String,
         osRev:String,osType:String,osVersion:String,version:String,
         machineArch:String){
        self.hostname = hostname
        self.machine = machine
        self.activeCPUs = activeCPUs
        self.osRelease = osRelease
        self.osRev = osRev
        self.osVersion = osVersion
        self.version = version
        self.machineArch = machineArch
        self.osType = osType
    }
}


extension SysctlDTO: Equatable {
    public static func ==(lhs: SysctlDTO, rhs: SysctlDTO) -> Bool {
        return
            lhs.activeCPUs == rhs.activeCPUs &&
            lhs.machine == rhs.machine &&
            lhs.osRelease == rhs.osRelease &&
            lhs.osRev == rhs.osRev &&
            lhs.osType == rhs.osType &&
            lhs.osVersion == rhs.osVersion
    }
}
