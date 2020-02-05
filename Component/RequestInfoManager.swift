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
    private var _domain : String?
    
    var customDomain : String {
        get {
        
            if let _domain = _domain {
                
                return _domain
            } else {
                
                return RSdkVars.DOMAIN
            }
            
        }
        set {
            
            _domain = newValue
        }
    }
    
    internal static var sharedRequestInfoManager = RSdkRequestInfoManager()
    private init() {
        self._customArgs = [String:String]()
    }
    
    func setupManager(_token : String, _snippetId : String, _domain: String?, _customArgs:[String:String]?) {
        
        self._token = _token
        self._snippetId = _snippetId
        self._domain = _domain
        self._customArgs = _customArgs ?? [String:String]()
        self._diMobileSdkVersion = mobileSdkVersion()
    }
    
    private func mobileSdkVersion() -> String {
        
        return RSdkVars.SDKVERSION
    }
    
    
}
