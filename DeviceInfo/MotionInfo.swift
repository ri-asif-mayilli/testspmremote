//
//  MotionInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 18.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import CoreMotion

struct RSdkMotionInfo {
    
    internal static var motionInfoDeviceMotionAvailable : Bool {
        
        return CMMotionManager().isDeviceMotionAvailable
    }

    internal static var motionInfoAccelerometerAvailable : Bool {
        
        return CMMotionManager().isAccelerometerAvailable
    }
    
    internal static var motionInfoGyroAvailable : Bool {
        
        return CMMotionManager().isGyroAvailable
    }
    
    internal static var motionInfoMagnetometerAvailable : Bool {
        
        return CMMotionManager().isMagnetometerAvailable
    }
    
    
    
}
