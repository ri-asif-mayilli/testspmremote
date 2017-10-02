//
//  CustomInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 11.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import CoreTelephony
import UIKit

class CustomInfo {
    
    public var applicationState : String {
        
        switch (UIApplication.shared.applicationState) {
            
        case .active:
            return "active"
            
        case .background:
            return "background"
            
        case.inactive:
            return "inactive"
        }
    }
}
