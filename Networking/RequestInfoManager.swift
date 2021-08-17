/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
//
//  RequestInfoManager.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 16.10.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation

internal class RSdkRequestInfoManager {
    
    var _token : String?
     var _snippetId : String?
    var _diMobileSdkVersion : String = ""
    var _customArgs: [String:String]
    var location : String?
    
    
    
   // internal static var sharedRequestInfoManager = RSdkRequestInfoManager()
    init() {
        self._customArgs = [String:String]()
    }
    
    func setupManager(_token : String, _snippetId : String, location:String?, _customArgs:[String:String]? = nil) {
        
        self._token = _token
        self._snippetId = _snippetId
        self.location = location
        self._customArgs = _customArgs ?? [String:String]()
        self._diMobileSdkVersion = mobileSdkVersion()
    }
    
    private func mobileSdkVersion() -> String {
        
        return RSdkVars.SDKVERSION
    }
    
    
}
