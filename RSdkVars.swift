/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
//
//  Vars.swift
//  MySDK
//
//  Created by Daniel Scheibe on 10.09.17.
//  Copyright © 2017 Daniel Scheibe. All rights reserved.
//

internal struct RSdkVars {
    
    internal static var SDKVERSION : String {
		return "10.10.11"  /*VERSION*/

    }
    
    internal struct RequestManagerVars {
        
        private static var _encodingType : [UInt8] = [58, 82, 41, 45, 3, 54, 36, 0, 29, 29, 54, 78, 38, 3, 13, 9, 79, 121, 20, 14, 7, 55, 38, 38, 31, 117, 48, 86, 74, 13, 26]
        internal static var encodingType : String {
            
            return Obfuscator.sharedObfuscator.revealObfuscation(key: _encodingType)
        }
        
        private static var _encodingHeaderType : [UInt8] = [24, 77, 55, 53, 15, 59, 49, 89, 32, 11, 40, 4]
        internal static var encodingHeaderType : String {
            
            return Obfuscator.sharedObfuscator.revealObfuscation(key: _encodingHeaderType)
        }
        
        private static var _xdib : [UInt8] = [35, 15, 61, 40, 71, 55]
        internal static var xdib : String {
            
            return Obfuscator.sharedObfuscator.revealObfuscation(key: _xdib)
        }
        
        private static var _xdibContentEncoding : [UInt8] = [24, 77, 55, 53, 15, 59, 49, 89, 49, 28, 59, 14, 40, 25, 12, 0]
        internal static var xdibContentEncoding : String {
            
            return Obfuscator.sharedObfuscator.revealObfuscation(key: _xdibContentEncoding)
        }
        
        
    }
    
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
    
    private static var _DOMAIN          : [UInt8] = [44, 85, 46, 111, 4, 58, 49, 29, 18, 27, 59, 0, 56, 25, 13, 9, 89, 45, 24, 9, 10, 107, 54, 44, 6]
    
    internal static var DOMAIN : String {

        return Obfuscator.sharedObfuscator.revealObfuscation(key: _DOMAIN)
    }
    
    private static var _POST_ENDPOINT_ENC : [UInt8] = [116, 75, 54, 50] // content: /ios/
    private static var POST_ENDPOINT_DEC : String  {
        
        return Obfuscator.sharedObfuscator.revealObfuscation(key: _POST_ENDPOINT_ENC)
    }
    
    private static var _ERROR_ENDPOINT_ENC : [UInt8] = [50, 77, 42, 108, 15, 39, 55]    // content: /ios-err/
    private static var ERROR_ENDPOINT_DEC : String  {
        
        return Obfuscator.sharedObfuscator.revealObfuscation(key: _ERROR_ENDPOINT_ENC)
    }
    
    
    private static var _SNIPPET_ENDPOINT_ENC : [UInt8] = [116, 70, 60, 44, 5, 122, 40, 27, 22, 27, 52, 4, 99]  // content: /demo/mobile/
    private static var SNIPPET_ENDPOINT_DEC : String  {
        
        return Obfuscator.sharedObfuscator.revealObfuscation(key: _SNIPPET_ENDPOINT_ENC)
    }
    
    private static var _ENDPOINT_ADDITIONAL_ENC : [UInt8] = [116, 86, 54, 42, 15, 59, 106] // content: /token/
    private static var ENDPOINT_ADDITIONAL_DEC  : String  {
        
        return Obfuscator.sharedObfuscator.revealObfuscation(key: _ENDPOINT_ADDITIONAL_ENC)
    }
    
    
    internal static var POST_PATH = "\(POST_ENDPOINT_DEC)"
    internal static var ERROR_PATH = "\(ERROR_ENDPOINT_DEC)"
    
    internal static var HOST = "\(Domain.sharedDomainManager.domain)"

    
    internal static var SNIPPET_ENDPOINT = "\(Domain.sharedDomainManager.domain)\(SNIPPET_ENDPOINT_DEC)"
    
    internal static var ENDPOINT_ADDITIONAL : String { return ENDPOINT_ADDITIONAL_DEC }


}

