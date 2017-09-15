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
    
    internal static func create(_ requestToken : String, customerID : String, completion: @escaping DeviceDTOCompletion) {
        
        createNotificationDTO(requestToken, customerID: customerID) {
         
            (deviceDTO) in
            
            completion(deviceDTO)
        }
    }
    
    private static func createNotificationDTO(_ requestToken: String, customerID: String, _ completion: @escaping DeviceDTOCompletion) {

        PushNotifications.enabled() {
            
            (bool) in
            
            let notificationDTO = NotificationDTO(enabled: bool)
            createProximityDTO(requestToken, customerID: customerID, notificationDTO: notificationDTO, withCompletion: completion)
            
        }
    }
    
    private static func createProximityDTO(_ requestToken: String, customerID: String, notificationDTO : NotificationDTO, withCompletion completion: @escaping DeviceDTOCompletion)  {
    
        Proximity.state() {
            
            (state) in
            
            let proximityDTO = ProximityDTO(state: state)
            let deviceDTO = DeviceDTO(requestToken, customerID: customerID, notificationDTO: notificationDTO, proximityDTO: proximityDTO)
            completion(deviceDTO)
        }
    }
    
    
    
}
