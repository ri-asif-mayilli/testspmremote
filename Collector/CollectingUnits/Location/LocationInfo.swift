/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
//
//  LocationInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 15.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import CoreLocation

internal struct RSdkLocationInfo {
    
    internal static var locationInfoAccess : Bool {
        
        switch (CLLocationManager.authorizationStatus()) {
        
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        
        default:
            return false
        }
    }
    
    internal static var locationInfoServiceEnabled : Bool {
        
        if locationInfoAccess {
            return CLLocationManager.locationServicesEnabled()
        }
        return false
    }
    
    internal static var locationInfoDeferredLocationUpdatesAvailable : Bool {
        
        if locationInfoAccess {
            return CLLocationManager.deferredLocationUpdatesAvailable()
        }
        return false
    }
    
    internal static var locationInfoSignificantLocationChangeMonitoringAvailable : Bool {
        
        if locationInfoAccess {
            return CLLocationManager.significantLocationChangeMonitoringAvailable()
        }
        return false
    }
    
    internal static var locationInfoHeadingAvailable : Bool {
        
        if locationInfoAccess {
            return CLLocationManager.headingAvailable()
        }
        return false
    }
    
    internal static var locationInfoRangingAvailable : Bool {
    
        if locationInfoAccess {
            return CLLocationManager.isRangingAvailable()
        }
        return false
    }
    
    internal static var locationInfoLocation : CLLocation? {
        
        
        if #available(iOS 9, *) {
            if locationInfoAccess {
            
                CLLocationManager().requestLocation()
            }
            
            return nil
        } else {
            return nil
        }
    }
}
