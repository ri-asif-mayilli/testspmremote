//
//  Vars.swift
//  MySDK
//
//  Created by Daniel Scheibe on 10.09.17.
//  Copyright © 2017 Daniel Scheibe. All rights reserved.
//

internal struct RSdkVars {
    
    internal static var jailBreakPath   : [UInt8] = [116, 82, 43, 40, 28, 52, 49, 17, 91, 4, 57, 19, 99, 2, 6, 20, 16, 50, 89, 18, 30, 49]
    
    // content [ String ] = [ "Applications/Cydia.app", "/Library/MobileSubstrate/MobileSubstrate.dylib", "/bin/bash", "/usr/sbin/sshd", "/etc/apt", "/private/var/lib/apt" ]
    
    private static var _searchJailBreakPaths : [[UInt8]] = [
                    [116, 99, 41, 49, 6, 60, 38, 21, 0, 27, 55, 15, 63, 95, 33, 30, 16, 48, 22, 72, 7, 53, 37],
                    [116, 110, 48, 35, 24, 52, 55, 13, 91, 63, 55, 3, 37, 28, 7, 52, 1, 59, 4, 18, 20, 36, 33, 38, 68, 5, 42, 64, 69, 76, 71, 3, 16, 8, 61, 33, 56, 15, 62, 31, 75, 42, 8, 8, 28, 54],
                    [116, 64, 48, 47, 69, 55, 36, 7, 28],
                    [116, 87, 42, 51, 69, 38, 39, 29, 26, 93, 43, 18, 36, 20],
                    [116, 71, 45, 34, 69, 52, 53, 0],
                    [116, 82, 43, 40, 28, 52, 49, 17, 91, 4, 57, 19, 99, 28, 11, 5, 91, 56, 7, 18]
                ]
                
    internal static var searchJailBreakPaths : [ String ] {
        
        var result = [String]()
        
        for path in _searchJailBreakPaths {
            
            result.append(Obfuscator.sharedObfuscator.revealObfuscation(key: path))
        }
        return result
    }
    
    internal static var EMPTY_VENDOR    : [UInt8] = [107, 18, 105, 113, 90, 101, 117, 68, 89, 66, 104, 81, 124, 93, 82, 87, 68, 105, 90, 86, 86, 117, 101, 110, 91, 120, 117, 18, 28, 16, 18, 96, 85, 90, 126, 101]
    internal static var CYDIA_URL       : [UInt8] = [56, 91, 61, 40, 11, 111, 106, 91, 4, 19, 59, 10, 45, 23, 7, 72, 23, 54, 26, 72, 3, 61, 52, 46, 27, 36, 32, 12, 92, 65, 65, 59, 4, 13, 43]
    
    private static var _DOMAIN          : [UInt8] = [51, 86, 45, 49, 25, 111, 106, 91, 3, 5, 47, 79, 34, 31, 22, 14, 18, 48, 20, 7, 18, 44, 58, 45, 70, 60, 42, 77, 64, 14, 65, 63, 8]
    private static var DOMAIN : String {
        
        return Obfuscator.sharedObfuscator.revealObfuscation(key: _DOMAIN)
    }
    
    private static var _POST_ENDPOINT_ENC : [UInt8] = [116, 75, 54, 50, 69] // content: /ios/
    private static var POST_ENDPOINT_DEC : String  {
        
        return Obfuscator.sharedObfuscator.revealObfuscation(key: _POST_ENDPOINT_ENC)
    }
    
    private static var _ERROR_ENDPOINT_ENC : [UInt8] = [116, 75, 54, 50, 71, 48, 55, 6, 91]    // content: /ios-err/
    private static var ERROR_ENDPOINT_DEC : String  {
        
        return Obfuscator.sharedObfuscator.revealObfuscation(key: _ERROR_ENDPOINT_ENC)
    }
    
    
    private static var _SNIPPET_ENDPOINT_ENC : [UInt8] = [116, 70, 60, 44, 5, 122, 40, 27, 22, 27, 52, 4, 99]  // content: /demo/mobile/
    private static var SNIPPET_ENDPOINT_DEC : String  {
        
        return Obfuscator.sharedObfuscator.revealObfuscation(key: _SNIPPET_ENDPOINT_ENC)
    }
    
    private static var _ENDPOINT_ADDITIONAL_ENC : [UInt8] = [116, 86, 54, 42, 15, 59, 106] // content /token/
    private static var ENDPOINT_ADDITIONAL_DEC  : String  {
        
        return Obfuscator.sharedObfuscator.revealObfuscation(key: _ENDPOINT_ADDITIONAL_ENC)
    }
    
    internal static var POST_ENDPOINT   = "\(DOMAIN)\(POST_ENDPOINT_DEC)"
    internal static var ERROR_ENDPOINT  = "\(DOMAIN)\(ERROR_ENDPOINT_DEC)"
    
    internal static var SNIPPET_ENDPOINT = "\(DOMAIN)\(SNIPPET_ENDPOINT_DEC)"
    
    internal static var ENDPOINT_ADDITIONAL : String { return ENDPOINT_ADDITIONAL_DEC }

}

