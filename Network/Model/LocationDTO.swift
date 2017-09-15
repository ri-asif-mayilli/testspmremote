//
//  LocationDTO.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 15.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

struct LocationDTO : Codable {

    let access = LocationInfo.access
    let serviceEnabled = LocationInfo.serviceEnabled
    let deferedLocationUpdates = LocationInfo.deferredLocationUpdatesAvailable
    let locationChangeMonitoring = LocationInfo.significantLocationChangeMonitoringAvailable
    let headingAvailable = LocationInfo.headingAvailable
    let rangingAvailable = LocationInfo.headingAvailable
}
