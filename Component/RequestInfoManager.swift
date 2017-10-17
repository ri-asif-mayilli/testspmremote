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
    
    internal static var sharedRequestInfoManager = RSdkRequestInfoManager()
    private init() {}
    
    func setupManager(_token : String, _snippetId : String) {
        
        self._token = _token
        self._snippetId = _snippetId
    }
    
    
}
