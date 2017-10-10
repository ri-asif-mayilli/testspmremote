//
//  LocationDTO.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 15.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import MapKit


internal struct LocationDTO : Codable {

    let access = RSdkLocationInfo.locationInfoAccess
    let serviceEnabled = RSdkLocationInfo.locationInfoServiceEnabled
    let deferredLocationUpdates = RSdkLocationInfo.locationInfoDeferredLocationUpdatesAvailable
    let locationChangeMonitoring = RSdkLocationInfo.locationInfoSignificantLocationChangeMonitoringAvailable
    let headingAvailable = RSdkLocationInfo.locationInfoHeadingAvailable
    let rangingAvailable = RSdkLocationInfo.locationInfoRangingAvailable
    var longitude : Double?
    var latitiude : Double?
    
    init () {
        
    }
    
    init(location: CLLocation) {
        
        self.longitude = location.coordinate.longitude
        self.latitiude = location.coordinate.latitude
        
    }
}
