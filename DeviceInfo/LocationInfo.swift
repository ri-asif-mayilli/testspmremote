//
//  LocationInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 15.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationInfo {
    
    internal static var access : Bool {
        
        switch (CLLocationManager.authorizationStatus()) {
        
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        
        default:
            return false
        }
    }
    
    internal static var serviceEnabled : Bool {
        
        if access {
            return CLLocationManager.locationServicesEnabled()
        }
        return false
    }
    
    internal static var deferredLocationUpdatesAvailable : Bool {
        
        if access {
            return CLLocationManager.deferredLocationUpdatesAvailable()
        }
        return false
    }
    
    internal static var significantLocationChangeMonitoringAvailable : Bool {
        
        if access {
            return CLLocationManager.significantLocationChangeMonitoringAvailable()
        }
        return false
    }
    
    internal static var headingAvailable : Bool {
        
        if access {
            return CLLocationManager.headingAvailable()
        }
        return false
    }
    
    internal static var rangingAvailable : Bool {
    
        if access {
            return CLLocationManager.isRangingAvailable()
        }
        return false
    }
    
    internal static var location : CLLocation? {
        
        if #available(iOS 9, *) {
            if access {
            
                CLLocationManager().requestLocation()
            }
            
            return nil
        } else {
            return nil
        }
        
    }
    
}
