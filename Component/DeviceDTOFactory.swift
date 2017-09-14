//
//  DeviceDTOFactory.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 12.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation

typealias DeviceDTOCompletion = (DeviceDTO) -> Void

internal class DeviceDTOFactory {
    
    internal static func create(completion: @escaping DeviceDTOCompletion) {
        
        createNotificationDTO() {
         
            (deviceDTO) in
            
            completion(deviceDTO)
        }
    }
    
    private static func createNotificationDTO(_ completion: @escaping DeviceDTOCompletion) {

        PushNotifications.enabled() {
            
            (bool) in
            
            let notificationDTO = NotificationDTO(enabled: bool)
            createProximityDTO(notificationDTO, withCompletion: completion)
            
        }
    }
    
    private static func createProximityDTO(_ notificationDTO : NotificationDTO, withCompletion completion: @escaping DeviceDTOCompletion)  {
    
        Proximity.state() {
            
            (state) in
            
            let proximityDTO = ProximityDTO(state: state)
            let deviceDTO = DeviceDTO(notificationDTO: notificationDTO, proximityDTO: proximityDTO)
            completion(deviceDTO)
        }
    }
    
    
    
}
