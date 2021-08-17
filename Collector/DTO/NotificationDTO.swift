//
//  NotificationDTO.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 09.06.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation
struct NotificationDTO : Codable {
    
    let enabled : Bool
    
    init(enabled: Bool) {
        
        self.enabled = enabled
    }
}


extension NotificationDTO:Equatable{
    public static func ==(lhs:NotificationDTO,rhs:NotificationDTO)->Bool{
        return lhs.enabled == rhs.enabled
    }
    
}
