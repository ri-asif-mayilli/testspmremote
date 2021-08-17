//
//  Domain.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 17.08.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation

class Domain{
    //static var domain:String
    
    
    class func getDomain()->String{
        var nsDictionary: NSDictionary?
         if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
            guard let domainDict = nsDictionary?["RsdkDomain"] else {return RSdkVars.DOMAIN}
            guard let domain = domainDict as? String else {return RSdkVars.DOMAIN}
            return domain
            
         }
        return RSdkVars.DOMAIN
    }
}
