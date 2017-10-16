//
//  RequestInfoManager.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 16.10.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation

internal class RSdkRequestInfoManager {
    
    var token : String?
    var snippetId : String?
    
    internal static var sharedRequestInfoManager = RSdkRequestInfoManager()
    private init() {}
    
    func setupManager(token : String, snippetId : String) {
        
        self.token = token
        self.snippetId = snippetId
    }
    
    
}
