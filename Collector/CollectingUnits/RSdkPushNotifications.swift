/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
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

struct RSdkPushNotifications {
    
    internal static func enabled(_ completion: @escaping (Bool) -> Void) {
        
        if #available(iOS 10, *) {
            enablediOS() {
                (enabled) in
                
                completion(enabled)
            }
        } else {
            completion( enabledLegacyiOS())
        }
    }
    
    private static func enabledLegacyiOS()->Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
    @available (iOS 10, *)
    private static func enablediOS(_ completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings() {
            (settings) in
            completion(settings.authorizationStatus == .authorized)
        }
    }  
}
