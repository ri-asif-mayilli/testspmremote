//
//  Vars.swift
//  MySDK
//
//  Created by Daniel Scheibe on 10.09.17.
//  Copyright © 2017 Daniel Scheibe. All rights reserved.
//

internal struct Vars {
    
    internal static var jailBreakPath : String {
        
        return "/private/var/rdsdk.txt"
    }
    
    internal static var EMPTY_VENDOR = "00000000-0000-0000-0000-000000000000"
    internal static var CYDIA_URL = "cydia://package/com.example.package"
    internal static var POST_ENDPOINT = "https://www-test-backup.jsctool.com/ios"
    internal static var ERROR_ENDPONT = "https://www-test-backup.jsctool.com/ios-err"
    internal static var INFO_ENABLE_LOCATION_CHECK = "RISK_LOCATION_CHECK"
    internal static var INFO_CUSTOMER_ID = "RISK_CUSTOMER_ID"
    internal static var INFO_APP_ID      = "RISK_APP_ID"
    internal static var INFO_APP_SECRET  = "RISK_APP_SECRET"
}

