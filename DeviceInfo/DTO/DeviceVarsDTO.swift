//
//  RSdkDeviceDTO.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 19.05.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation

struct DeviceVarsDTO : Codable {
    
    let name:String
    let model:String
    let localizedModel:String
    let systemName:String
    let systemVersion:String
    let orientationNotification:Bool
    let deviceOrientation:String
    let multitasking:Bool
    let isSimulator:Bool
    
    
    init() {
        self.name = RSdkDeviceInfo.deviceInfoNameObfuscated
        self.model = RSdkDeviceInfo.deviceInfoModel
        self.localizedModel = RSdkDeviceInfo.deviceInfoLocalizedModel
        self.systemName = RSdkDeviceInfo.deviceInfoSystemName
        self.systemVersion = RSdkDeviceInfo.deviceInfoSystemVersion
        self.orientationNotification = RSdkDeviceInfo.deviceInfoOrientationNotifaction
        self.deviceOrientation = RSdkDeviceInfo.deviceInfoDeviceOrientation
        self.multitasking = RSdkDeviceInfo.deviceInfoMultitaskingSupported
        self.isSimulator = RSdkDeviceInfo.deviceInfoIsSimulator
    }
    
    init(name:String,model:String,localizedModel:String,systemName:String,systemVersion:String,
         orientationNotification:Bool,deviceOrientation:String,multitasking:Bool,isSimulator:Bool) {
        self.name = name
        self.model = model
        self.localizedModel = localizedModel
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.orientationNotification = orientationNotification
        self.deviceOrientation = deviceOrientation
        self.multitasking = multitasking
        self.isSimulator = isSimulator
    }
}

extension DeviceVarsDTO: Equatable {
    public static func ==(lhs: DeviceVarsDTO, rhs: DeviceVarsDTO) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.model == rhs.model &&
            lhs.localizedModel == rhs.localizedModel &&
            lhs.systemVersion == rhs.systemVersion &&
            lhs.orientationNotification == rhs.orientationNotification &&
            lhs.deviceOrientation == rhs.deviceOrientation &&
            lhs.multitasking == rhs.multitasking &&
            lhs.isSimulator == rhs.isSimulator
    }
}
