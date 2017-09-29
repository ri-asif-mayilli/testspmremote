//
//  RandomizeLocation.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 18.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import MapKit

public class RSdkLocation {
    
    var latitude  : Double = 0
    var longitude : Double = 0
    
    init() {
        
    }
    
    init(latitude: Double, longitude: Double) {
        
        self.latitude = latitude
        self.longitude = longitude
    }
}

public class LocationUtility
{
    
    public static func makeLocationCoarse(fromCLLocation location : CLLocation) -> CLLocation?
    
    {
        let granularityInMeters : Double = 10 * 1000;
        
        let newLocation = RSdkLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        return makeLocationCoarse2(location: newLocation, granularityInMeters: granularityInMeters);
    }
   
    public static func makeLocationCoarse2(location : RSdkLocation, granularityInMeters : Double) -> CLLocation {
        
        let courseLocation = RSdkLocation()

        if(location.latitude == Double(0) &&  location.longitude == Double(0)) {
            // Special marker, don't bother.
        } else {

        var granularityLat : Double = 0;
        var granularityLon : Double = 0;

//        {
            // Calculate granularityLat
//            {
                let angleUpInRadians : Double = 0;
            let newLocationUp : RSdkLocation = getLocationOffsetBy(fromLocation: location, offsetInMeters: granularityInMeters, angleInRadians: angleUpInRadians);

                granularityLat = location.latitude - newLocationUp.latitude;

                if(granularityLat < Double(0)) {

                    granularityLat = -granularityLat;
                }
//            }

            // Calculate granularityLon
//            {

                let angleRightInRadians : Double = 1.57079633;
            let newLocationRight : RSdkLocation = getLocationOffsetBy(fromLocation: location, offsetInMeters: granularityInMeters, angleInRadians: angleRightInRadians);

                granularityLon = location.longitude - newLocationRight.longitude;

                if(granularityLon < Double(0)) {
                    granularityLon = -granularityLon;
                }
//            }
//        }

            var courseLatitude : Double = location.latitude
            var courseLongitude : Double = location.longitude
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

        courseLocation.latitude = courseLatitude
        courseLocation.longitude = courseLongitude
        }

        
        return CLLocation(latitude: courseLocation.latitude, longitude: courseLocation.longitude)
//        return courseLocation
        
    }
    
    public static func calculateGranularity() {
        
        
        
    }
    
    public static func makeLocationCoarse(location : RSdkLocation, granularityInMeters : Double) -> CLLocation? {
        
        if(location.latitude == 0 && location.longitude == 0) {
            
            return nil

        } else {

            let angleUpInRadians : Double = 0;
            let newLocationUp: RSdkLocation  = getLocationOffsetBy(fromLocation: location, offsetInMeters: granularityInMeters, angleInRadians: angleUpInRadians);
        
            var granularityLat : Double = location.latitude - newLocationUp.latitude
        
            if(granularityLat < 0) {
                granularityLat = -granularityLat;
            }

            let angleRightInRadians : Double = 1.57079633
            let newLocationRight : RSdkLocation = getLocationOffsetBy(fromLocation: location, offsetInMeters: granularityInMeters, angleInRadians: angleRightInRadians)
        
            var granularityLon : Double = location.longitude - newLocationRight.latitude
        
            if(granularityLon < 0) {
                
                granularityLon = -granularityLon;
            }
            
            var courseLatitude : Double = location.latitude;
            var courseLongitude : Double = location.longitude;
        
            if(granularityLon == 0 || granularityLat == 0) {
            
                courseLatitude = 0;
                courseLongitude = 0;
            } else {

                let courseInt = Int((courseLatitude / granularityLat) * granularityLat)
                let courseLong = Int((courseLongitude / granularityLon) * granularityLon)
                courseLatitude = Double(Int(courseLatitude / granularityLat)) * granularityLat;
                courseLongitude = Double(Int(courseLongitude / granularityLon)) * granularityLon;
                
                let loc = CLLocation(latitude: Double(courseInt), longitude: Double(courseLong))
//                print (loc)
                
                return loc
            }
        
//            print("course latitude: \(courseLatitude)")
//            print("couse longitude: \(courseLongitude)")
            
            return nil
        }
    }
    
    // http://www.movable-type.co.uk/scripts/latlong.html
    private static func getLocationOffsetBy(fromLocation location : RSdkLocation, offsetInMeters : Double, angleInRadians : Double) -> RSdkLocation {

        let lat1 : Double = deg2rad(location.latitude);
        let lon1 : Double = deg2rad(location.longitude);
        
        let distanceKm : Double = offsetInMeters / 1000;
        let earthRadiusKm : Double = 6371;
        
        let lat2 : Double = asin( sin(lat1)*cos(distanceKm/earthRadiusKm) +
        cos(lat1)*sin(distanceKm/earthRadiusKm)*cos(angleInRadians) );
        
        let lon2 : Double = lon1 +
        atan2(sin(angleInRadians)*sin(distanceKm/earthRadiusKm)*cos(lat1),
        cos(distanceKm/earthRadiusKm)-sin(lat1)*sin(lat2));
        
        return RSdkLocation(latitude: rad2deg(lat2), longitude: rad2deg(lon2))
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
