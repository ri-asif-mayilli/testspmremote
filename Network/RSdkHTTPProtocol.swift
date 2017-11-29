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
    ///   - _location: String : Optional Location String
    ///   - completion: (Error) -> Void : Completion Handler which give Back Error to App (Error)
    internal class func postDeviceData(_snippetId : String, _requestToken: String? = nil, _location: String? = nil, _completion: @escaping (Error?) -> Void) {
        
        guard let requestToken = _requestToken else { return }
        
        DeviceDTOFactory.createDTO(_snippetId: _snippetId, _requestToken: requestToken, _location: _location, _completion: { (device) in
            
            postBin(device: device) {
                (error) in
                
                _completion(error)
            }
        })
    }
    
    private class func postBin(device : RSdkDeviceDTO, completionHandler: @escaping (Error?) -> Void) {
        
        DispatchQueue.global(qos: .userInteractive).async {
        
            RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postBin(deviceDTO: device)) {
                
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


