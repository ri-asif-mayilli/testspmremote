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
    
    var _token : String?
    var _snippetId : String?
    var networkInterface: NetworkInterface = NetworkInterface()
    fileprivate var uuidToken : String {
        
        get {
            
            if let _token = _token {
                
                return _token
            } else {
                
                _token = UUID().uuidString
                return _token ?? ""
            }
        }
        
        set (newToken) {
            
            _token = newToken
        }
    }


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
    @objc public init(snippetId: String, token: String, domain: String? = nil, location: String? = nil,customArgs: [ String : String ]? = nil) {
    
        super.init()
        uuidToken = token
        _snippetId = snippetId

        initializeRDskRequest(domain: domain, location: location, customArgs: customArgs)
    }
    
    private func initializeRDskRequest(domain: String? = nil, location: String? = nil, customArgs: [ String : String ]? = nil) {
        guard let snippetId = _snippetId else {
            return
        }

        RSdkRequestInfoManager.sharedRequestInfoManager.setupManager(_token: uuidToken, _snippetId: snippetId, _domain: domain, _customArgs: customArgs)
        
        networkInterface.postDeviceData(_snippetId: snippetId, _token: uuidToken, _location: location, _mobileSdkVersion: RSdkRequestInfoManager.sharedRequestInfoManager._diMobileSdkVersion) {
            
            (error) in
            
            if let error = error as NSError? {
                
                RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .postNativeData(snippetId, self.uuidToken, error.debugDescription))) 
            }
        }
    }
    

}
