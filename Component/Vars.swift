//
//  Vars.swift
//  MySDK
//
//  Created by Daniel Scheibe on 10.09.17.
//  Copyright © 2017 Daniel Scheibe. All rights reserved.
//

internal struct Vars {
    
    internal static var SNIPPET_ID = "ios-sdk-test"
    
    internal static var jailBreakPath : String {
        
        return "/private/var/rdsdk.txt"
    }
    
    internal static var EMPTY_VENDOR = "00000000-0000-0000-0000-000000000000"
    internal static var CYDIA_URL = "cydia://package/com.example.package"
    
    internal static var POST_ENDPOINT = "https://www-backup-test.jsctool.com/ios"
    internal static var ERROR_ENDPOINT = "https://www-backup-test.jsctool.com/ios-err"

}

