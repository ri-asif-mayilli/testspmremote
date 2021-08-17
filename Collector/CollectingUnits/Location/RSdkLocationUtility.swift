/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
//
//  RandomizeLocation.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 18.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import MapKit

internal class RSdkLocation {
    
    var locationLatitude  : Double = 0
    var locationLongitude : Double = 0
    
    init() {
        
    }
    
    init(locationLatitude: Double, locationLongitude: Double) {
        
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
    }
}

internal class RSdkLocationUtility
{
    
    internal static func makeLocationCoarse(fromCLLocation _location : CLLocation) -> CLLocation?
    
    {
        let granularityInMeters : Double = 10 * 1000;
        
        let newLocation = RSdkLocation(locationLatitude: _location.coordinate.latitude, locationLongitude: _location.coordinate.longitude)
        return makeLocationCoarse2(_location: newLocation, granularityInMeters: granularityInMeters);
    }
   
    private static func makeLocationCoarse2(_location : RSdkLocation, granularityInMeters : Double) -> CLLocation {
        
        let courseLocation = RSdkLocation()

        if(_location.locationLatitude == Double(0) &&  _location.locationLongitude == Double(0)) {
            // Special marker, don't bother.
        } else {

        var granularityLat : Double = 0;
        var granularityLon : Double = 0;

//        {
            // Calculate granularityLat
//            {
                let angleUpInRadians : Double = 0;
            let newLocationUp : RSdkLocation = getLocationOffsetBy(fromLocation: _location, offsetInMeters: granularityInMeters, angleInRadians: angleUpInRadians);

                granularityLat = _location.locationLatitude - newLocationUp.locationLatitude;

                if(granularityLat < Double(0)) {

                    granularityLat = -granularityLat;
                }
//            }

            // Calculate granularityLon
//            {

                let angleRightInRadians : Double = 1.57079633;
            let newLocationRight : RSdkLocation = getLocationOffsetBy(fromLocation: _location, offsetInMeters: granularityInMeters, angleInRadians: angleRightInRadians);

                granularityLon = _location.locationLongitude - newLocationRight.locationLongitude;

                if(granularityLon < Double(0)) {
                    granularityLon = -granularityLon;
                }
//            }
//        }

            var courseLatitude : Double = _location.locationLatitude
            var courseLongitude : Double = _location.locationLongitude
//        {

            if(granularityLon == Double(0) || granularityLat == Double(0)) {

                courseLatitude = 0;
                courseLongitude = 0;
            } else {

                courseLatitude = Double(Int(courseLatitude / granularityLat)) *
                granularityLat;

                courseLongitude = Double(Int(courseLongitude / granularityLon)) *
                granularityLon;
            }
//        }

        courseLocation.locationLatitude = courseLatitude
        courseLocation.locationLongitude = courseLongitude
        }

        
        return CLLocation(latitude: courseLocation.locationLatitude, longitude: courseLocation.locationLongitude)
//        return courseLocation
        
    }
    
    private static func calculateGranularity() {
        
        
        
    }
    
    private static func makeLocationCoarse(_location : RSdkLocation, granularityInMeters : Double) -> CLLocation? {
        
        if(_location.locationLatitude == 0 && _location.locationLongitude == 0) {
            
            return nil

        } else {

            let angleUpInRadians : Double = 0;
            let newLocationUp: RSdkLocation  = getLocationOffsetBy(fromLocation: _location, offsetInMeters: granularityInMeters, angleInRadians: angleUpInRadians);
        
            var granularityLat : Double = _location.locationLatitude - newLocationUp.locationLatitude
        
            if(granularityLat < 0) {
                granularityLat = -granularityLat;
            }

            let angleRightInRadians : Double = 1.57079633
            let newLocationRight : RSdkLocation = getLocationOffsetBy(fromLocation: _location, offsetInMeters: granularityInMeters, angleInRadians: angleRightInRadians)
        
            var granularityLon : Double = _location.locationLongitude - newLocationRight.locationLatitude
        
            if(granularityLon < 0) {
                
                granularityLon = -granularityLon;
            }
            
            var courseLatitude : Double = _location.locationLatitude;
            var courseLongitude : Double = _location.locationLongitude;
        
            if(granularityLon == 0 || granularityLat == 0) {
            
                courseLatitude = 0;
                courseLongitude = 0;
            } else {

                let courseInt = Int((courseLatitude / granularityLat) * granularityLat)
                let courseLong = Int((courseLongitude / granularityLon) * granularityLon)
                courseLatitude = Double(Int(courseLatitude / granularityLat)) * granularityLat;
                courseLongitude = Double(Int(courseLongitude / granularityLon)) * granularityLon;

                let loc = CLLocation(latitude: Double(courseInt), longitude: Double(courseLong))
                return loc
            }
         
            return nil
        }
    }
    
    private static func getLocationOffsetBy(fromLocation _location : RSdkLocation, offsetInMeters : Double, angleInRadians : Double) -> RSdkLocation {

        let lat1 : Double = deg2rad(_location.locationLatitude);
        let lon1 : Double = deg2rad(_location.locationLongitude);
        
        let distanceKm : Double = offsetInMeters / 1000;
        let earthRadiusKm : Double = 6371;
        
        let lat2 : Double = asin( sin(lat1)*cos(distanceKm/earthRadiusKm) +
        cos(lat1)*sin(distanceKm/earthRadiusKm)*cos(angleInRadians) );
        
        let lon2 : Double = lon1 +
        atan2(sin(angleInRadians)*sin(distanceKm/earthRadiusKm)*cos(lat1),
        cos(distanceKm/earthRadiusKm)-sin(lat1)*sin(lat2));
        
        return RSdkLocation(locationLatitude: rad2deg(lat2), locationLongitude: rad2deg(lon2))
    }
    
    private static func rad2deg(_ radians: Double) -> Double
    {
        let ratio : Double = (180.0 / 3.141592653589793238);
        return radians * ratio;
    }
    
    private static func deg2rad(_ radians: Double) -> Double
    {
        let ratio : Double = (180.0 / 3.141592653589793238);
        return radians / ratio;
    }
    
    /*
     public: static void testCoarse()
     {
     Location vancouver(49.2445, -123.099146);
     Location vancouver2 = makeLocationCoarse(vancouver);
     
     Location korea(37.423938, 126.692488);
     Location korea2 = makeLocationCoarse(korea);
     
     Location hiroshima(34.3937, 132.464);
     Location hiroshima2 = makeLocationCoarse(hiroshima);
     
     Location zagreb(45.791958, 15.935786);
     Location zagreb2 = makeLocationCoarse(zagreb);
     
     Location anchorage(61.367778, -149.900208);
     Location anchorage2 = makeLocationCoarse(anchorage);
     }*/
};
