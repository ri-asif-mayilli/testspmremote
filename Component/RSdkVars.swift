//
//  Vars.swift
//  MySDK
//
//  Created by Daniel Scheibe on 10.09.17.
//  Copyright © 2017 Daniel Scheibe. All rights reserved.
//

internal struct RSdkVars {
    
    internal static var SNIPPET_ID = "ios-sdk-test"
    
    internal static var jailBreakPath : String {
        
        return "/private/var/rdsdk.txt"
    }
    
    internal static var EMPTY_VENDOR = "00000000-0000-0000-0000-000000000000"
    internal static var CYDIA_URL = "cydia://package/com.example.package"
    
    internal static var SNIPPET_DOMAIN = ""
    internal static var DOMAIN = "https://www-backup-test.jsctool.com/"
    
    internal static var POST_ENDPOINT   = "\(DOMAIN)/ios"
    internal static var ERROR_ENDPOINT  = "\(DOMAIN)/ios-err"
    
    internal static var SNIPPET_ENDPOINT = "\(DOMAIN)/demo/mobile/"

}

