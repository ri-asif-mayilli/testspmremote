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
    
    /// Returns a class with all Jailbreak Informationes
    ///
    internal class var info : JailbreakDTO? {
        
        #if arch(i386) || arch(x86_64)
            
            return nil
        #else
            
            return generate
        #endif
    }
    
    internal class var existingPath : [String] {
        
        var pathExists = [String]()
        
        let paths = [ "/Applications/Cydia.app",
                      "/Library/MobileSubstrate/MobileSubstrate.dylib",
                      "/bin/bash",
                      "/usr/sbin/sshd",
                      "/etc/apt",
                      "/private/var/lib/apt" ]
        
        for path in paths {
            
            if FileManager.default.fileExists(atPath: path) {
                
                pathExists.append(path)
            }
        }
        
        return pathExists
    }
    
    internal class var sandboxBreak : Bool {
        
        return writeIdFile("")
    }
    
    internal class var isJailbroken : Bool {
        
        return existingPath.count != 0 || cydiaInstalled || sandboxBreak
    }

    private class var sandBoxUniqueID : JailbreakDTO? {
        
        do {
            
            let idString = try String(contentsOfFile: RSdkVars.jailBreakPath, encoding: .utf8)
            if let jsonData = idString.data(using: .utf8) {
                
                let decoder = JSONDecoder()
                return try decoder.decode(JailbreakDTO.self, from: jsonData)
            } else {
                
                return nil
            }
            
        }
        catch {

            return nil
        }
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
    
    @available(iOS 10, *)
    private static var cydiaIOS10 : () -> Bool = {

        guard let url = URL(string: RSdkVars.CYDIA_URL) else { return false }
        var result = false
        
        UIApplication.shared.open(url, options: [:]) {

            (bool) in

            result = bool
        }

        return result
    }

    private class var cydiaIOS9 : Bool {
        
        guard let url = URL(string: "cydia://package/com.example.package") else { return false }
        let result = UIApplication.shared.canOpenURL(url)
        return result
    }
    
    private class var generate : JailbreakDTO? {
        
        if !isJailbroken {
            
            return nil
        }
        
        var uniqueSandBoxId : JailbreakDTO
        if let sandBoxId = sandBoxUniqueID {
            
            uniqueSandBoxId = sandBoxId
            uniqueSandBoxId.created = Date()
        } else {
            
            uniqueSandBoxId = JailbreakDTO(appID: UUID().uuidString, created: Date(), existingPaths: existingPath)
        }
        
        do {
            
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(uniqueSandBoxId), let idString = String(data: data, encoding: .utf8) {
                
                let _ = writeIdFile(idString)
            }
        }
        
        return uniqueSandBoxId
    }
    
    private class func writeIdFile(_ idString : String) -> Bool {
        
        do {
            
            try idString.write(toFile:RSdkVars.jailBreakPath, atomically:true, encoding:String.Encoding.utf8)
            return true
        } catch {
            
            return false
        }
    }
    
}
