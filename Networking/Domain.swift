//
//  Domain.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 17.08.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation

class Domain{
    internal static var sharedDomainManager = Domain()
    var domain : String = RSdkVars.DOMAIN
}
