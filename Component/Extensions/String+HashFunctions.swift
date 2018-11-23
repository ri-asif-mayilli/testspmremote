//
//  String+HashFunctions.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 15.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    
    var djb2hash: Int {
        
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
    
    var djb2hashString: String {
        
        return String(self.djb2hash)
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

    var sha256: String {

        guard let data = self.sha256Data else { return "" }
        let nsData = NSData.init(data: data)
        let sha256String = nsData.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "")
        return sha256String
    }

    var sha256Data: Data? {

        guard let data = self.data(using: .utf8) else { return nil }
        var hash = [UInt8](repeating: 0, count: Int(32))
        data.withUnsafeBytes { _ = CC_SHA256($0, CC_LONG(data.count), &hash) }
        return Data(bytes: hash)
    }
}

