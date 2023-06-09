/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
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
    
    let _locationManager : CLLocationManager
    let _locationManagerDelegate = RSdkLocationManagerDelegate()
    
    public static let sharedLocationManager = RSdkLocationManager()
    private init() {
  
        _locationManager = CLLocationManager()
        _locationManager.delegate = _locationManagerDelegate
    }
    
    var locationCompletion : ((CLLocation?, Error?) -> Void)?
    var headingCompletion : ((CLHeading?, Error?) -> Void)?
    
    internal func setLocationCompletion(_ completion: @escaping (CLLocation?, Error?) -> Void) {
        
        concurrentQueue.async(flags: .barrier) {
         
            self._locationManagerDelegate.delegate = self
            if self.locationCompletion != nil { return }
            self.locationCompletion = completion
        }
    }
    
    fileprivate let concurrentQueue =
        DispatchQueue(
            label: "com.clientsecurity.clientsecuritylocationmanager", // 1
            attributes: .concurrent) // 2
    
    @available(iOS 9, *)
    internal func getLocation(_ completion: @escaping (CLLocation?, Error?) -> Void) {
        
        concurrentQueue.async(flags: .barrier) {
            
            self._locationManagerDelegate.delegate = self
            if self.locationCompletion != nil { return }
            self.locationCompletion = completion
            self._locationManager.requestLocation()
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
     
        _locationManager.requestAlwaysAuthorization()
     }
}

extension RSdkLocationManager : LocationManagerDelegateProtocol {
    
    func locationComplete(withLocation _location: CLLocation) {
    
        concurrentQueue.async(flags: .barrier) {
        
            if let completion = self.locationCompletion {
                
                completion(nil, nil)
                self.locationCompletion = nil
            }
        }
    }
    
    func locationComplete(withError error: Error, _location: Bool) {
    
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
    
    func locationComplete(withLocation _location: CLLocation)
    func locationComplete(withHeading _location: CLHeading)
    func locationComplete(withError error: Error, _location: Bool)
}

class RSdkLocationManagerDelegate : NSObject, CLLocationManagerDelegate {

    let privateQueue = DispatchQueue(label: "com.clientsecurity.clientsecuritylocationmanagerdelegate", attributes: .concurrent)
    
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

        delegate?.locationComplete(withError: error, _location: true)
    }
}
