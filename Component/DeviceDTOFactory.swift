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
    
    internal static func createDTO(snippetId: String, requestToken: String, location: String? = nil, geoLocation: CLLocation?, completion: @escaping RSdkDeviceDTOCompletion) {
        
        createNotificationDTO(snippetId: snippetId, requestToken: requestToken, location: location, geoLocation: geoLocation) {
         
            (deviceDTO) in
            
            completion(deviceDTO)
        }
    }
    
    private static func createNotificationDTO(snippetId: String, requestToken: String, location: String? = nil, geoLocation: CLLocation?, completion: @escaping RSdkDeviceDTOCompletion) {

        RSdkPushNotifications.enabled() {
            
            (bool) in
            
            let notificationDTO = NotificationDTO(enabled: bool)
            createProximityDTO(snippetId: snippetId, requestToken: requestToken, location: location, geoLocation: geoLocation, notificationDTO: notificationDTO, withCompletion: completion)
            
        }
    }
    
    private static func createProximityDTO(snippetId: String, requestToken: String, location: String? = nil, geoLocation: CLLocation?, notificationDTO : NotificationDTO, withCompletion completion: @escaping RSdkDeviceDTOCompletion)  {
    
        RSdkProximity.rsdkState() {
            
            (state) in
            
            let proximityDTO = ProximityDTO(state: state)
            let deviceDTO = RSdkDeviceDTO(snippetId, requestToken: requestToken, location: location ?? "", geoLocation: geoLocation, notificationDTO: notificationDTO, proximityDTO: proximityDTO)
            completion(deviceDTO)
        }
    }
    
    
    
}
