/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
//
//  HTTPProtocol.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 31.08.17.
//  Copyright © 2017 RISK.IDENT GMBH. All rights reserved.
//

import Foundation
import CoreLocation



internal class NetworkInterface {
    //It should not be static, current design does not allow to use instance variable
    
    /// Post Native iOS Data to Risk Ident Backend
    ///
    /// - Parameters:
    ///   - snippetId : String : The Customer Snippet ID
    ///   - _token: String : The Token for the Request
    ///   - _location: String : Optional Location String
    ///   - _mobileSdkVersion: String The current SDK of this build
    ///   - completion: (Error) -> Void : Completion Handler which give Back Error to App (Error)
    internal  func postDeviceData(_snippetId : String, _token: String, _location: String? = nil, _mobileSdkVersion: String, _completion: @escaping (Error?) -> Void) {
    

        DeviceDTOFactory.createDTO(_snippetId: _snippetId, _requestToken: _token, _location: _location, _mobileSdkVersion: _mobileSdkVersion, _completion: { (device,error) in
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                RSdkRequestManager.sharedRequestManager.doRequest( requestType:.postBin(deviceDTO: device)) {
                    (data, requestError) in
                    if error != nil {
                        NetworkService.sharedRequestManager.request(router: .postError(error: .postNativeData(_snippetId, _token, requestError.debugDescription)))
                    }
                }
                RSdkRequestManager.sharedRequestManager.doRequest( requestType:.postBin(deviceDTO: device)) {
                    (data, requestError) in
                    if error != nil {
                        NetworkService.sharedRequestManager.request(router: .postError(error: .postNativeData(_snippetId, _token, requestError.debugDescription)))
                    }
                }
                if let error = error{
                    NetworkService.sharedRequestManager.request(router: .postCombinedErrors(error: error))
                }
               
                _completion(nil)
                
            }
            
        })
    }
    
}


