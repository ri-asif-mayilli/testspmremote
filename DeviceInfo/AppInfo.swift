//
//  AppInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 18.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation

struct AppInfo {
    
    private static var getPlist : [String : Any]? {
        
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist")
            else { return nil }
        
        let url = URL(fileURLWithPath: path)
        do {
            
        let data = try Data(contentsOf: url)
            return try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String : Any]
            
        } catch let error {
     
            print(error)
        }
        return nil
    }
    
    internal static var infoPlistAvailable : Bool {
        
        guard let _ = Bundle.main.path(forResource: "Info", ofType: "plist") else { return false }
        return true
    }
    
    internal static var bundleName : String {
        
        if let plist = getPlist {
            
            print(plist)
        }
        return ""
    }
    
    internal static var bundleExecutable : String {

        if let plist = getPlist {
            

        }
        return ""
    }
    
    internal static var enableLocation : Bool? {
        
        return false
    }
    
    internal static var customerID : String? {
                
        return nil
    }
    
    internal static var appID : String? {
        
        return nil
    }
    
    internal static var appSecret : String? {
        
        return nil
    }
}
