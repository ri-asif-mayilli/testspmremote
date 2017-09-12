//
//  File.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 12.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

struct PushNotifications {
    
    internal static func enabled(_ completion: @escaping (Bool) -> Void) {
        
        if #available(iOS 10, *) {
            enablediOS() {
                (enabled) in
                
                completion(enabled)
            }
        } else {
            
            enabledLegacyiOS() {
                (enabled) in
                
                completion(enabled)
            }
        }
    }
    
    private static func enabledLegacyiOS(_ completion: (Bool) -> Void) {
        
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            
            completion(true)
            
        } else {
            
            completion(false)
        }
    }
    
    @available (iOS 10, *)
    private static func enablediOS(_ completion: @escaping (Bool) -> Void) {
    
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings() {
            
            (settings) in
            let status = settings.authorizationStatus
            
            switch(status) {
                
            case .authorized:
                completion(true)
                
            default:
                completion(false)
            }
        }
    }
}
