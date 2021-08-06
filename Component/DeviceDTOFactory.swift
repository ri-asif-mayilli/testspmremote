/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
//
//  DeviceDTOFactory.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 12.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import MapKit

typealias RSdkDeviceDTOCompletion = (RSdkDeviceDTO,RSDKNewErrorDTO?) -> Void

internal class DeviceDTOFactory {
    
    internal static func createDTO(_snippetId: String, _requestToken: String, _location: String? = nil, _mobileSdkVersion: String, _completion: @escaping RSdkDeviceDTOCompletion) {
        
        createNotificationDTO(_snippetId: _snippetId, _requestToken: _requestToken, _location: _location, _mobileSdkVersion: _mobileSdkVersion) {
         
            (deviceDTO,errorDTO) in
            
            _completion(deviceDTO,errorDTO)
        }
    }
    
    private static func createNotificationDTO(_snippetId: String, _requestToken: String, _location: String? = nil, _mobileSdkVersion: String, _completion: @escaping RSdkDeviceDTOCompletion) {

        RSdkPushNotifications.enabled() {
            
            (bool) in
            
            let _notificationDTO = NotificationDTO(enabled: bool)
            createProximityDTO(_snippetId: _snippetId, _requestToken: _requestToken, _location: _location, _mobileSdkVersion: _mobileSdkVersion, _notificationDTO: _notificationDTO, _withCompletion: _completion)
            
        }
    }
    
    private static func createProximityDTO(_snippetId: String, _requestToken: String, _location: String? = nil, _mobileSdkVersion: String, _notificationDTO : NotificationDTO, _withCompletion _completion: @escaping RSdkDeviceDTOCompletion)  {
    
        RSdkProximity.rsdkProximityState() {
            
            (state) in
            
            let _proximityDTO = ProximityDTO(state: state)
            let _deviceDTO = RSdkDeviceDTO(_snippetId, requestToken: _requestToken, _location: _location ?? "", mobileSdkVersion: _mobileSdkVersion, notificationDTO: _notificationDTO, proximityDTO: _proximityDTO)
            _completion(_deviceDTO,_deviceDTO.collectErrors())
        }
    }
    
    
    
}
