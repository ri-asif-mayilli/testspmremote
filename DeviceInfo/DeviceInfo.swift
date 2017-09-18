//
//  DeviceInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 11.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import UIKit

struct DeviceInfo {
    
    internal static var name : String {
        
        return UIDevice.current.name
    }
    
    internal static var model : String {
        
        return UIDevice.current.model
    }
    
    internal static var localizedModel : String {
        
        return UIDevice.current.localizedModel
    }
    
    internal static var systemName : String {
        
        return UIDevice.current.systemName
    }
    
    internal static var systemVersion : String {
        
        return UIDevice.current.systemVersion
    }
    
    internal static var orientationNotifaction : String {
        
        return UIDevice.current.isGeneratingDeviceOrientationNotifications.description
    }
    
    internal static var deviceOrientation : String {
        
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
    
    internal static var multitaskingSupported : Bool {
    
        return UIDevice.current.isMultitaskingSupported
    
    }
    
    internal static var isSimulator : Bool {
        
        #if (arch(i386) || arch(x86_64))
            
            return true
        #endif
        return false
    }

}

struct Display {
    
    internal static var userInterfaceIdiom : String {
        
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
    
    static var brightness : Float {
        
        return Float(UIScreen.main.brightness)
    }
    
    private static var screenBound : CGRect {
        
        return UIScreen.main.bounds
    }
    
    static var screenBoundMinX : Float {
        
        return Float(screenBound.minX)
    }
    
    static var screenBoundMaxX : Float {
        
        return Float(screenBound.maxX)
    }
    
    static var screenBoundMinY : Float {
        
        return Float(screenBound.minY)
    }
    
    static var screenBoundMaxY : Float {
        
        return Float(screenBound.maxY)
    }
    
    static var screenBoundHeight : Float {
        
        return Float(screenBound.height)
    }
    
    static var screenBoundWidth : Float {
        
        return Float(screenBound.width)
    }
    
    static var screenScale : Float {
        
        return Float(UIScreen.main.scale)
    }
    
    static var screenSizeHeight : Float {
        
        return Float(screenBound.size.height)
    }
    
    static var screenSizeWidth : Float {
        
        return Float(screenBound.size.width)
    }
    
    static var userInterfaceLayout : String {
        
        switch UIApplication.shared.userInterfaceLayoutDirection {
            
        case .leftToRight:
            return "leftToRight"
            
        case .rightToLeft:
            return "rightToLeft"
        }
    }
}

struct Battery {

    static var monitoringEnabled : Bool {
        
        return UIDevice.current.isBatteryMonitoringEnabled
    }
    
    static var state : String {
        
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
    
    static var level : Float {
        
        return UIDevice.current.batteryLevel
    }
}

struct Proximity {
 
    static var monitoringEnabled : Bool {
        
        return UIDevice.current.isProximityMonitoringEnabled
    }
    
    internal static func state(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
        
            var weEnabled = false
            if !monitoringEnabled {
             
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
