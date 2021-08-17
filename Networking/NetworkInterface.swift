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
    /// Post Native iOS Data to Risk Ident Backend
    ///
    /// - Parameters:
    ///   - snippetId : String : The Customer Snippet ID
    ///   - _token: String : The Token for the Request
    ///   - _location: String : Optional Location String
    ///   - _mobileSdkVersion: String The current SDK of this build
    ///   - completion: (Error) -> Void : Completion Handler which give Back Error to App (Error)
    internal  func postDeviceData(requestInfoManager: RSdkRequestInfoManager, _completion: @escaping (Error?) -> Void) {
        guard let token = requestInfoManager._token, let snippetId = requestInfoManager._snippetId else {return}

        DeviceDTOFactory.createDTO(requestInfoManager:requestInfoManager, _completion: { (device,error) in
            
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                NetworkService.sharedRequestManager.request( router:.postBin(payload: device,requestInfo:requestInfoManager)) {
                    (data, requestError) in
                    if error != nil {
                        NetworkService.sharedRequestManager.request(router: .postError(error: .postNativeData(snippetId, token, requestError.debugDescription),requestInfo:requestInfoManager))
                    }
                }
                NetworkService.sharedRequestManager.request( router:.postClientBin(payload: device,requestInfo:requestInfoManager)) {
                    (data, requestError) in
                    if error != nil {
                        NetworkService.sharedRequestManager.request(router: .postError(error: .postNativeData(snippetId, token, requestError.debugDescription),requestInfo:requestInfoManager))
                    }
                }
                if let error = error{
                    NetworkService.sharedRequestManager.request(router: .postCombinedErrors(error: error,requestInfo:requestInfoManager))
                }
                _completion(nil)
            }
        })
    }
}


