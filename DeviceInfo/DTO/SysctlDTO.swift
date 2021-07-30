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
    let sysctl = SysctlNew()
    private enum CodingKeys: String, CodingKey {
            case hostname, machine, activeCPUs, osRelease, osRev, osType, osVersion, version, machineArch, memSize, bootTimestamp
        }
    
        /*
         
     case .model:
         return Sysctl.sysctlModel
         
     case .memSize:
         return Sysctl.sysctlMemSize.description
         
     case .bootTimestamp:
         return String(describing: Sysctl.bootTimestamp)

     }
     */
    init(){
        self.hostname = sysctl.sysctlHostName.djb2hashString.sha256
        self.machine = sysctl.sysctlMachine
        self.activeCPUs = String(describing:sysctl.sysctlActiveCPUs)
        self.osRelease = sysctl.sysctlOsRelease
        self.osRev = String(describing: sysctl.sysctlKernID)
        self.osVersion = sysctl.sysctlOsVersion
        self.version = sysctl.sysctlVersion
        self.machineArch = sysctl.sysctlMachineArch
        self.osType = sysctl.sysctlOsType
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
    
    func errors() -> [String]{
        return self.sysctl.errors
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
            lhs.osVersion == rhs.osVersion &&
            lhs.version == rhs.version
    }
}
