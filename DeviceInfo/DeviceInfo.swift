//
//  DeviceInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 11.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import UIKit

internal struct DeviceInfo {
    
    internal static var deviceInfoName : String {
        
        return UIDevice.current.name
    }
    
    internal static var deviceInfoModel : String {
        
        return UIDevice.current.model
    }
    
    internal static var deviceInfoLocalizedModel : String {
        
        return UIDevice.current.localizedModel
    }
    
    internal static var deviceInfosystemName : String {
        
        return UIDevice.current.systemName
    }
    
    internal static var deviceInfoSystemVersion : String {
        
        return UIDevice.current.systemVersion
    }
    
    internal static var deviceInfoOrientationNotifaction : Bool {
        
        return UIDevice.current.isGeneratingDeviceOrientationNotifications
    }
    
    internal static var deviceInfoDeviceOrientation : String {
        
        let orientation = UIDevice.current.orientation
        switch(orientation) {
            
        case .faceDown:
            return "faceDown"
            
        case .faceUp:
            return "faceUp"
            
        case .landscapeLeft:
            return "landscapeLeft"
            
        case .landscapeRight:
            return "landscapeRight"
            
        case .portrait:
            return "portrait"
            
        case .portraitUpsideDown:
            return "portraitUpsideDown"
            
        case .unknown:
            return "unknown"
        }
    }
    
    internal static var deviceInfoMultitaskingSupported : Bool {
    
        return UIDevice.current.isMultitaskingSupported
    
    }
    
    internal static var deviceInfoIsSimulator : Bool {
        
        #if (arch(i386) || arch(x86_64))
            
            return true
        #endif
        return false
    }

}

internal struct RSdkDisplay {
    
    internal static var rsdkDisplayUserInterfaceIdiom : String {
        
        let idiom = UIDevice.current.userInterfaceIdiom
        switch(idiom) {
            
        case .unspecified:
            return "unspecified"
        case .phone:
            return "phone"
        case .pad:
            return "pad"
        case .tv:
            return "tvOS"
        case .carPlay:
            return "carPlay"
        }
    }
    
    static var rsdkBrightness : Float {
        
        return Float(UIScreen.main.brightness)
    }
    
    private static var rsdkScreenBound : CGRect {
        
        return UIScreen.main.bounds
    }
    
    static var rsdkScreenBoundMinX : Float {
        
        return Float(rsdkScreenBound.minX)
    }
    
    static var rsdkScreenBoundMaxX : Float {
        
        return Float(rsdkScreenBound.maxX)
    }
    
    static var rsdkScreenBoundMinY : Float {
        
        return Float(rsdkScreenBound.minY)
    }
    
    static var rsdkScreenBoundMaxY : Float {
        
        return Float(rsdkScreenBound.maxY)
    }
    
    static var rsdkScreenBoundHeight : Float {
        
        return Float(rsdkScreenBound.height)
    }
    
    static var rsdkScreenBoundWidth : Float {
        
        return Float(rsdkScreenBound.width)
    }
    
    static var rsdkScreenScale : Float {
        
        return Float(UIScreen.main.scale)
    }
    
    static var rsdkScreenSizeHeight : Float {
        
        return Float(rsdkScreenBound.size.height)
    }
    
    static var rsdkScreenSizeWidth : Float {
        
        return Float(rsdkScreenBound.size.width)
    }
    
    static var rsdkUserInterfaceLayout : String {
        
        switch UIApplication.shared.userInterfaceLayoutDirection {
            
        case .leftToRight:
            return "leftToRight"
            
        case .rightToLeft:
            return "rightToLeft"
        }
    }
}

internal struct RSdkBattery {

    static var rsdkMonitoringEnabled : Bool {
        
        return UIDevice.current.isBatteryMonitoringEnabled
    }
    
    static var rsdkState : String {
        
        var weEnabled = false
        
        if UIDevice.current.isBatteryMonitoringEnabled == false {
            
            weEnabled = true
            UIDevice.current.isBatteryMonitoringEnabled = !UIDevice.current.isBatteryMonitoringEnabled
        }
        
        let state = UIDevice.current.batteryState
        if weEnabled {
            
            UIDevice.current.isBatteryMonitoringEnabled = !UIDevice.current.isBatteryMonitoringEnabled
        }
        
        switch(state) {
            
        case .charging:
            return "charging"
        case .unplugged:
            return "unplugged"
        case .full:
            return "full"
        case .unknown:
            return "unknown"
        }
    }
    
    static var rsdkLevel : Float {
        
        return UIDevice.current.batteryLevel
    }
}

internal struct RSdkProximity {
 
    static var rsdkMonitoringEnabled : Bool {
        
        return UIDevice.current.isProximityMonitoringEnabled
    }
    
    internal static func rsdkState(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
        
            var weEnabled = false
            if !rsdkMonitoringEnabled {
             
                weEnabled = true
                UIDevice.current.isProximityMonitoringEnabled = !UIDevice.current.isProximityMonitoringEnabled
            }
            
            let state = UIDevice.current.proximityState
            
            if weEnabled {
             
                UIDevice.current.isProximityMonitoringEnabled = !UIDevice.current.isProximityMonitoringEnabled
            }
            
                completion(state)
        }
    }
}
