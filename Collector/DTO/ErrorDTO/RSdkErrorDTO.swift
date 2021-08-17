/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
//
//  RSdkErrorDTO.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 16.10.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation

struct RSdkErrorDTO : Codable {
    let errorCode: Int
    let errorDescription: String
    let sdkVersion: String
    
    internal init(_ errorType : RSdkErrorType) {
       
        self.errorCode = errorType._code
        self.errorDescription = errorType._description
        self.sdkVersion = RSdkVars.SDKVERSION
    }
}
