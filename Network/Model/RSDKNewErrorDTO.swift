//
//  RSDKNewErrorDTO.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 02.08.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation

class RSDKNewErrorDTO: Codable{
    let errorDescription: String
    let sdkVersion: String
    let snippetId: String
    let token: String
    internal init(errors:String,snippetId:String,token:String) {
        self.errorDescription = errors
        self.sdkVersion = RSdkVars.SDKVERSION
        self.snippetId = snippetId
        self.token = token
    }
}

