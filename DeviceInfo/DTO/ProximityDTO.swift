//
//  ProximityDTO.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 08.06.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation
struct ProximityDTO : Codable {
    
    let monitoringEnabled: Bool
    let state: Bool
    
    init(state : Bool) {
        
        self.state = state
        self.monitoringEnabled = RSdkProximity.rsdkProximityMonitoringEnabled
    }
    
    init(state: Bool,enabled: Bool) {
        
        self.state = state
        self.monitoringEnabled = enabled
    }
}

extension ProximityDTO: Equatable {
    public static func ==(lhs: ProximityDTO, rhs: ProximityDTO) -> Bool {
        return
            lhs.state == rhs.state &&
            lhs.monitoringEnabled == rhs.monitoringEnabled
    }
}
