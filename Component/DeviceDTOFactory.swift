//
//  DeviceDTOFactory.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 12.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import MapKit

typealias RSdkDeviceDTOCompletion = (RSdkDeviceDTO) -> Void

internal class DeviceDTOFactory {
    
    internal static func create(_ requestToken : String, location: CLLocation?, action : String, completion: @escaping RSdkDeviceDTOCompletion) {
        
        createNotificationDTO(requestToken, location: location, customerID: action) {
         
            (deviceDTO) in
            
            completion(deviceDTO)
        }
    }
    
    private static func createNotificationDTO(_ requestToken: String, location: CLLocation?, customerID: String, _ completion: @escaping RSdkDeviceDTOCompletion) {

        RSdkPushNotifications.enabled() {
            
            (bool) in
            
            let notificationDTO = NotificationDTO(enabled: bool)
            createProximityDTO(requestToken, customerID: customerID, location: location, notificationDTO: notificationDTO, withCompletion: completion)
            
        }
    }
    
    private static func createProximityDTO(_ requestToken: String, customerID: String, location: CLLocation?, notificationDTO : NotificationDTO, withCompletion completion: @escaping RSdkDeviceDTOCompletion)  {
    
        Proximity.state() {
            
            (state) in
            
            let proximityDTO = ProximityDTO(state: state)
            let deviceDTO = RSdkDeviceDTO(requestToken, action: customerID, location: location, notificationDTO: notificationDTO, proximityDTO: proximityDTO)
            completion(deviceDTO)
        }
    }
    
    
    
}
