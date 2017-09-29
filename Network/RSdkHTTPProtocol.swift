//
//  HTTPProtocol.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 31.08.17.
//  Copyright © 2017 RISK.IDENT GMBH. All rights reserved.
//

import Foundation
import CoreLocation

public class RSdkHTTPProtocol {
    
    
    /// Post Native iOS Data to Risk Ident Backend
    ///
    /// - Parameters:
    ///   - requestToken: String : The Token for the Request
    ///   - customerID: String : The Token for the customer
    ///   - enableLocationFinder: Bool -> Enable Location Finder, Default is false (WIP)
    ///   - location : CLLocation -> Give the User Location to the Framework. Default ist nil (WIP)
    ///   - completion: (Error) -> Void : Completion Handler which give Back Error to App (Error)
    public class func post(_ requestToken: String, action: String, enableLoactionFinder: Bool = false, location: CLLocation? = nil, completion: @escaping (Error?) -> Void) {
        
        DeviceDTOFactory.create(requestToken, location: location,action: action, completion: { (device) in
            
            postBin(device: device) {
                (error) in
                
                completion(error)
            }
        })
    }
    
    private class func postBin(device : RSdkDeviceDTO, completionHandler: @escaping (Error?) -> Void) {
        
        DispatchQueue.global(qos: .userInteractive).async {
        
            RSdkRequestManager.shared.doRequest(requestType: .postBin(deviceDTO: device)) {
                
                (data, error) in
                
                if let error = error {
                    
                    completionHandler(error)
                    return
                }
                completionHandler(nil)
            }
        }
    }
}


