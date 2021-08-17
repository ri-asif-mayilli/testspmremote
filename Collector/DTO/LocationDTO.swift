/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
//
//  LocationDTO.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 15.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import MapKit


internal struct LocationDTO : Codable {
    let access:Bool
    let serviceEnabled:Bool
    let deferredLocationUpdates:Bool
    let locationChangeMonitoring:Bool
    let headingAvailable:Bool
    let rangingAvailable:Bool
    var longitude : Double?
    var latitiude : Double?
    
    init () {
        self.access = RSdkLocationInfo.locationInfoAccess
        self.serviceEnabled = RSdkLocationInfo.locationInfoServiceEnabled
        self.deferredLocationUpdates = RSdkLocationInfo.locationInfoDeferredLocationUpdatesAvailable
        self.locationChangeMonitoring = RSdkLocationInfo.locationInfoSignificantLocationChangeMonitoringAvailable
        self.headingAvailable = RSdkLocationInfo.locationInfoHeadingAvailable
        self.rangingAvailable = RSdkLocationInfo.locationInfoRangingAvailable
    }
    
    init(_location: CLLocation) {
        self.init()
        self.longitude = _location.coordinate.longitude
        self.latitiude = _location.coordinate.latitude
    }
}
