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

public protocol RSdkHTTPProtocolDelegate {
    func updateViews(token:String)
}

public class RSdkHTTPProtocol {
    //It should not be static, current design does not allow to use instance variable
    static public var delegate:RSdkHTTPProtocolDelegate?
    
    /// Post Native iOS Data to Risk Ident Backend
    ///
    /// - Parameters:
    ///   - snippetId : String : The Customer Snippet ID
    ///   - _token: String : The Token for the Request
    ///   - _location: String : Optional Location String
    ///   - _mobileSdkVersion: String The current SDK of this build
    ///   - completion: (Error) -> Void : Completion Handler which give Back Error to App (Error)
    internal class func postDeviceData(_snippetId : String, _token: String, _location: String? = nil, _mobileSdkVersion: String, _completion: @escaping (Error?) -> Void) {
    

        DeviceDTOFactory.createDTO(_snippetId: _snippetId, _requestToken: _token, _location: _location, _mobileSdkVersion: _mobileSdkVersion, _completion: { (device) in
            postBin(device: device) { postBinError in
                if(postBinError != nil) {
                    
                    RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .postNativeData(_snippetId, _token, postBinError.debugDescription)))
                    _completion(nil)
                }else{
                    delegate?.updateViews(token: _token)
                }
            }
            postClientBin(device: device) { error in
                if(error != nil) {
                    RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .postNativeData(_snippetId, _token, error.debugDescription))) 
                    _completion(nil)
                }
            }
            
        })
    }
    
    private class func postBin(device : RSdkDeviceDTO, completionHandler: @escaping (Error?) -> Void) {
        
        DispatchQueue.global(qos: .userInteractive).async {
        
            RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postBin(deviceDTO: device)) {
                (data, error) in
                completionHandler(error)
            }
        }
    }
    
    private class func postClientBin(device : RSdkDeviceDTO, completionHandler: @escaping (Error?) -> Void) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postClientBin(deviceDTO: device)) { (data, error) in
                completionHandler(error)
            }
        }
    }
}


