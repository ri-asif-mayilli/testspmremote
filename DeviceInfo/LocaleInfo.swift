//
//  LocaleInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 18.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation

struct LocaleInfo {
    
    internal static var preferredLanguages : [String] {
        
        return NSLocale.preferredLanguages
    }
    
    internal static var localTimeZone : String {
        
        return TimeZone.current.identifier
    }
    
}
