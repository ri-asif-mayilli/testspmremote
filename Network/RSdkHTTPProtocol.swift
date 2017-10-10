//
//  HTTPProtocol.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 31.08.17.
//  Copyright © 2017 RISK.IDENT GMBH. All rights reserved.
//

import Foundation
import CoreLocation

internal class RSdkHTTPProtocol {
    
    
    /// Post Native iOS Data to Risk Ident Backend
    ///
    /// - Parameters:
    ///   - snippetId : String : The Customer Snippet ID
    ///   - requestToken: String : The Token for the Request
    ///   - location: String : Optional Location String
    ///   - enableLocationFinder: Bool -> Enable Location Finder, Default is false (WIP)
    ///   - geoLocation : CLLocation -> Give the User Location to the Framework. Default ist nil (WIP)
    ///   - completion: (Error) -> Void : Completion Handler which give Back Error to App (Error)
    internal class func postDeviceData(snippetId : String, requestToken: String? = nil, location: String? = nil, enableLoactionFinder: Bool = false, geoLocation: CLLocation? = nil, completion: @escaping (Error?) -> Void) {
        
        guard let requestToken = requestToken else { return }
        
        DeviceDTOFactory.createDTO(snippetId: snippetId, requestToken: requestToken, location: location, geoLocation: geoLocation, completion: { (device) in
            
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


