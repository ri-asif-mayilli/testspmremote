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

typealias RSdkDeviceDTOCompletion = (RSdkDeviceDTO,RSDKCombinedErrorDTO?) -> Void

internal class DeviceDTOFactory {
    
    internal static func createDTO(requestInfoManager:RSdkRequestInfoManager, _completion: @escaping RSdkDeviceDTOCompletion) {
        
        createNotificationDTO(requestInfoManager:requestInfoManager) {
         
            (deviceDTO,errorDTO) in
            
            _completion(deviceDTO,errorDTO)
        }
    }
    
    private static func createNotificationDTO(requestInfoManager:RSdkRequestInfoManager, _completion: @escaping RSdkDeviceDTOCompletion) {

        RSdkPushNotifications.enabled() {
            
            (bool) in
            
            let _notificationDTO = NotificationDTO(enabled: bool)
            createProximityDTO(requestInfoManager:requestInfoManager, _notificationDTO: _notificationDTO, _withCompletion: _completion)
            
        }
    }
    
    private static func createProximityDTO(requestInfoManager:RSdkRequestInfoManager, _notificationDTO : NotificationDTO, _withCompletion _completion: @escaping RSdkDeviceDTOCompletion)  {
    
        RSdkProximity.rsdkProximityState() {
            
            (state) in
            
            RSdkNetworkInfo.getSsid(){ssid in
                let networkDTO = NetworkInfoDTO(ssid:ssid)
                let _proximityDTO = ProximityDTO(state: state)
                let _deviceDTO = RSdkDeviceDTO(requestInfoManager:requestInfoManager, notificationDTO: _notificationDTO, proximityDTO: _proximityDTO, networkInfoDTO: networkDTO)
                _completion(_deviceDTO,_deviceDTO.collectErrors())
            }
           
        }
    }
    
    
//    private static func createNetworkDTO(requestInfoManager:RSdkRequestInfoManager, _networkDTO:NetworkInfoDTO, _withCompletion _completion: @escaping RSdkDeviceDTOCompletion){
//        RSdkNetworkInfo.getSsid(){ssid in
//            let networkDTO = NetworkInfoDTO(ssid:ssid)
//        }
//        
//    }
    
    
}
