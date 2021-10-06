//
//  Extensions.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 05.10.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation


extension Date{
    static func setDate(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter.string(from: date)
            
    
    }
}

