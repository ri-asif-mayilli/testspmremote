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
    private init() {}
    
    func setupManager(_token : String, _snippetId : String, _domain: String?) {
        
        self._token = _token
        self._snippetId = _snippetId
        self._domain = _domain
    }
    
    
    
    
}
