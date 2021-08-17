/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
//
//  Browser.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 31.08.17.
//  Copyright © 2017 RISK.IDENT GMBH. All rights reserved.
//

import Foundation
import UIKit

public class ClientSecurityModule : NSObject {
    
    var networkInterface: NetworkInterface = NetworkInterface()
    var requestInfoManager:RSdkRequestInfoManager = RSdkRequestInfoManager()

    /// This is the Client Security Module.
    ///
    /// Usage:
    ///
    /// Just init the Module and store locally the refernce to it globally.
    ///
    /// - Parameters:
    ///   - snippetId: String -> The snippet id
    ///   - token: String -> A Unique execution UUID for the Call.
    ///   - location: String -> String for ?
    ///   - domain: String -> An custom Domain
    ///   - customArgs: [ String : String ] -> Dictionary of Strings. Default: nil
    @objc public init(snippetId: String) {
        super.init()
        requestInfoManager._snippetId = snippetId
    }
    
    public func sendData(token: String, location: String? = nil,customArgs: [ String : String ]? = nil, completion:  ((String?,String?,Bool?)->Void)? = nil){
        
        guard let snippetId = requestInfoManager._snippetId else {
            completion?("No snippetId",token,false)
            return
        }

        self.requestInfoManager.setupManager(_token: token, _snippetId: snippetId, location: location, _customArgs: customArgs)
        
        networkInterface.postDeviceData( requestInfoManager: self.requestInfoManager) {
            
            (error) in
            
            if let error = error as NSError?, let token = self.requestInfoManager._token  {
                
                NetworkService.sharedRequestManager.request(router: .postError(error: .postNativeData(snippetId, token, error.debugDescription),requestInfo: self.requestInfoManager))
                completion?(error.debugDescription,token,false)
            } else{
                completion?(nil,token,true)
            }
        }
    }
}
