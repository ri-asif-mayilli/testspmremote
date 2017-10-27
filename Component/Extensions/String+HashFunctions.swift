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

//// MARK: - SHA256
//var sha256hash : String {
//    guard let data = self.data(using: .utf8) else {
//        print("Data not available")
//        return ""
//    }
//    return getHexString(fromData: digest(input: data as NSData))
//}
//
//private func digest(input : NSData) -> NSData {
//    let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
//    var hashValue = [UInt8](repeating: 0, count: digestLength)
//    CC_SHA256(input.bytes, UInt32(input.length), &hashValue)
//    return NSData(bytes: hashValue, length: digestLength)
//}
//
//private  func getHexString(fromData data: NSData) -> String {
//    var bytes = [UInt8](repeating: 0, count: data.length)
//    data.getBytes(&bytes, length: data.length)
//    
//    var hexString = ""
//    for byte in bytes {
//        hexString += String(format:"%02x", UInt8(byte))
//    }
//    return hexString
//}

