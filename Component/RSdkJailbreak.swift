/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
//
//  Jailbreak.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 11.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import UIKit

internal class RSdkJailbreak {
    
    internal class var isJailbroken : Bool {
        
        return !jbExistingPath.isEmpty || cydiaInstalled || sandboxBreak
    }
    
    
    internal class var jbExistingPath : [String] {
        
        var pathExists = [String]()
        
        for path in RSdkVars.searchJailBreakPaths {
            
            if FileManager.default.fileExists(atPath: path) {
                
                pathExists.append(path)
            }
        }
        
        return pathExists
    }
    
    @available(iOS 10, *)
    private static var cydiaIOS10 : () -> Bool = {

        guard let url = URL(string: Obfuscator.sharedObfuscator.revealObfuscation(key: RSdkVars.CYDIA_URL)) else { return false }
        var result = false
        
        UIApplication.shared.open(url, options: [:]) {

            (bool) in

            result = bool
        }

        return result
    }

    private class var cydiaIOS9 : Bool {
        
        guard let url = URL(string: Obfuscator.sharedObfuscator.revealObfuscation(key: RSdkVars.CYDIA_URL)) else { return false }
        let result = UIApplication.shared.canOpenURL(url)
        return result
    }
    

    
    
    internal class var sandboxBreak : Bool {
        
        return jbWriteIdFile("")
    }
    


    internal class var cydiaInstalled : Bool {
        
        if #available(iOS 10, *) {
        
            var result = false
            
            DispatchQueue.main.async {

                result = cydiaIOS10()
            }
            return result
        } else {
        
            return cydiaIOS9
        }
    }
    
    
    private class func jbWriteIdFile(_ idString : String) -> Bool {
        
        do {
            
            try idString.write(toFile: Obfuscator.sharedObfuscator.revealObfuscation(key: RSdkVars.jailBreakPath), atomically:true, encoding:String.Encoding.utf8)
            return true
        } catch {
            return false
        }
    }
    
}
