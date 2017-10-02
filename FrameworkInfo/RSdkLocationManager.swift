//
//  LocationManager.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 15.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import CoreLocation

internal class RSdkLocationManager {
    
    let locationManager : CLLocationManager
    let locationManagerDelegate = LocationManagerDelegate()
    
    public static let shared = RSdkLocationManager()
    private init() {
  
        locationManager = CLLocationManager()
        locationManager.delegate = locationManagerDelegate
    }
    
    var locationCompletion : ((CLLocation?, Error?) -> Void)?
    var headingCompletion : ((CLHeading?, Error?) -> Void)?
    
    internal func setLocationCompletion(_ completion: @escaping (CLLocation?, Error?) -> Void) {
        
        concurrentQueue.async(flags: .barrier) {
         
            self.locationManagerDelegate.delegate = self
            if self.locationCompletion != nil { return }
            self.locationCompletion = completion
        }
    }
    
    fileprivate let concurrentQueue =
        DispatchQueue(
            label: "com.riskidenkt.risksdk.locationmanager", // 1
            attributes: .concurrent) // 2
    
    @available(iOS 9, *)
    internal func getLocation(_ completion: @escaping (CLLocation?, Error?) -> Void) {
        
        concurrentQueue.async(flags: .barrier) {
            
            self.locationManagerDelegate.delegate = self
            if self.locationCompletion != nil { return }
            self.locationCompletion = completion
            self.locationManager.requestLocation()
        }
    }
    
    @available(iOS 9, *)
    internal func getHeading(_ completion: @escaping (CLHeading?, Error?) -> Void) {
        
        concurrentQueue.async(flags: .barrier) {
            if self.headingCompletion != nil { return }
            self.headingCompletion = completion
        }
    }

    @available(iOS 9, *)
    internal func requestAuth() {
     
        locationManager.requestAlwaysAuthorization()
     }
}

extension RSdkLocationManager : LocationManagerDelegateProtocol {
    
    func locationComplete(withLocation location: CLLocation) {
    
        concurrentQueue.async(flags: .barrier) {
        
            if let completion = self.locationCompletion {
                
                completion(nil, nil)
                self.locationCompletion = nil
            }
        }
    }
    
    func locationComplete(withError error: Error, location: Bool) {
    
        concurrentQueue.async(flags: .barrier) {
        
            if let completion = self.locationCompletion {
                completion(nil, error)
                self.locationCompletion = nil
            }
        }
    }
    
    func locationComplete(withHeading heading: CLHeading) {
    
        concurrentQueue.async(flags: .barrier) {
            if let completion = self.headingCompletion {
                
                completion(heading, nil)
                self.locationCompletion = nil
            }
        }
    }
    
    
}

protocol LocationManagerDelegateProtocol {
    
    func locationComplete(withLocation location: CLLocation)
    func locationComplete(withHeading heading: CLHeading)
    func locationComplete(withError error: Error, location: Bool)
}

class LocationManagerDelegate : NSObject, CLLocationManagerDelegate {

    let privateQueue = DispatchQueue(label: "com.riskidenkt.risksdk.locationmanagerdelegate", attributes: .concurrent)
    
    private var _delegate : LocationManagerDelegateProtocol?
    
    internal var delegate : LocationManagerDelegateProtocol? {
        get {
            return _delegate
        }
        set (newValue){
            privateQueue.async(flags: .barrier) {
                if self._delegate == nil {
                    self._delegate = newValue
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        delegate?.locationComplete(withHeading: newHeading)
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            delegate?.locationComplete(withLocation: locations[0])
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        delegate?.locationComplete(withError: error, location: true)
    }
}
