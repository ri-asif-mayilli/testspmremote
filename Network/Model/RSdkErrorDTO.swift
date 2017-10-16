//
//  RSdkErrorDTO.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 16.10.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation

struct RSdkErrorDTO : Codable {
    
    let snippetId        : String
    let requestToken     : String
    let errorCode        : Int
    let errorDescription : String
    
    internal init(_ errorType : RSdkErrorType) {
       
        self.snippetId          = errorType.snippetId
        self.requestToken       = errorType.requestToken
        self.errorCode          = errorType.code
        self.errorDescription   = errorType.description
        
    }
}
