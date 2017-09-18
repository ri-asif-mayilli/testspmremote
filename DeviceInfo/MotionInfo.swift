//
//  MotionInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 18.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import CoreMotion

struct MotionInfo {
    
    internal static var deviceMotionAvailable : Bool {
        
        return CMMotionManager().isDeviceMotionAvailable
    }

    internal static var accelerometerAvailable : Bool {
        
        return CMMotionManager().isAccelerometerAvailable
    }
    
    internal static var gyroAvailable : Bool {
        
        return CMMotionManager().isGyroAvailable
    }
    
    internal static var magnetometerAvailable : Bool {
        
        return CMMotionManager().isMagnetometerAvailable
    }
    
    
    
}
