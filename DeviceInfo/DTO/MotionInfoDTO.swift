//
//  MotionInfoDTO.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 08.06.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation
internal struct MotionInfoDTO : Codable {
    
    let accelerometerAvailable:Bool
    let deviceMotionAvailable:Bool
    let magnetometerAvailable:Bool
    let gyroAvailable:Bool
    
    init(){
        self.accelerometerAvailable = RSdkMotionInfo.motionInfoAccelerometerAvailable
        self.deviceMotionAvailable = RSdkMotionInfo.motionInfoDeviceMotionAvailable
        self.magnetometerAvailable = RSdkMotionInfo.motionInfoMagnetometerAvailable
        self.gyroAvailable = RSdkMotionInfo.motionInfoGyroAvailable
    }
    
    init(accelerometerAvailable:Bool, deviceMotionAvailable:Bool, magnetometerAvailable:Bool, gyroAvailable:Bool){
        self.accelerometerAvailable = accelerometerAvailable
        self.deviceMotionAvailable = deviceMotionAvailable
        self.magnetometerAvailable = magnetometerAvailable
        self.gyroAvailable = gyroAvailable
    }
}


extension MotionInfoDTO: Equatable {
    public static func ==(lhs: MotionInfoDTO, rhs: MotionInfoDTO) -> Bool {
        return
            lhs.accelerometerAvailable == rhs.accelerometerAvailable &&
            lhs.deviceMotionAvailable == rhs.deviceMotionAvailable &&
            lhs.magnetometerAvailable == rhs.magnetometerAvailable &&
            lhs.gyroAvailable == rhs.gyroAvailable
    }
}
