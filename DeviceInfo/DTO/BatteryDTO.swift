//
//  BatteryDTO.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 20.05.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation
struct BatteryDTO  : Codable {

    let batteryMonitoringEnabled:Bool
    let batteryState:String
    let batteryLevel:Float
    
    init() {
        self.batteryMonitoringEnabled = RSdkBattery.rsdkMonitoringEnabled
        self.batteryState    = RSdkBattery.rsdkBatteryState
        self.batteryLevel    = RSdkBattery.rsdkLevel
    }
    
    init(monitoringEnabled:Bool,state:String,level:Float){
        self.batteryMonitoringEnabled = monitoringEnabled
        self.batteryState = state
        self.batteryLevel = level
        
    }
}

extension BatteryDTO: Equatable {
    public static func ==(lhs: BatteryDTO, rhs: BatteryDTO) -> Bool {
        return
            lhs.batteryMonitoringEnabled == rhs.batteryMonitoringEnabled &&
            lhs.batteryState == rhs.batteryState &&
            lhs.batteryLevel == rhs.batteryLevel
    }
}
