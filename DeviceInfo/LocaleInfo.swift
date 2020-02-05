//
//  LocaleInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 18.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation

internal struct RSdkLocaleInfo {
    
    internal static var localeInfoPreferredLanguages : [String] {
        
        return NSLocale.preferredLanguages
    }
    
    internal static var localeInfoLocalTimeZone : String {
        
        return TimeZone.current.identifier
    }
    
}
