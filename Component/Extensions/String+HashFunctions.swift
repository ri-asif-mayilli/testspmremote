//
//  String+HashFunctions.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 15.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation

extension String {
    
    var djb2hash: Int {
        
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
        
    var sdbmhash: Int {
        
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(0) {
            Int($1) &+ ($0 << 6) &+ ($0 << 16) - $0
        }
    }
    
    var htmlEncoded : String? {
            
            let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
            return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
}
