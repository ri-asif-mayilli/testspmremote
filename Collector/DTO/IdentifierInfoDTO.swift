//
//  IdentifierInfoDTO.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 07.06.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation

internal struct IdentifierInfoDTO : Codable {    
    let vendorId:String?
    let advertTrackingEnabled:Bool
    let uniqueAppId:String?
    let localStorageId:String
    
    
    init(){
        //Should I assign empty string literal or leave nil
        self.vendorId = RSdkIdentifierInfo.identifierInfoVendor
        self.advertTrackingEnabled = RSdkIdentifierInfo.identifierInfoIsAdvertisingEnabled
        self.uniqueAppId = RSdkIdentifierInfo.identifierUniqueAppIdentifier
        self.localStorageId = RSdkIdentifierInfo.identifierlocalStorage.djb2hashString.sha256
    }
    
    init(vendorId:String?,advertTrackingEnabled:Bool,uniqueAppId:String?,localStorageId:String){
        self.vendorId = vendorId
        self.advertTrackingEnabled = advertTrackingEnabled
        self.uniqueAppId = uniqueAppId
        self.localStorageId = localStorageId
    }
}

extension IdentifierInfoDTO: Equatable {
    public static func ==(lhs: IdentifierInfoDTO, rhs: IdentifierInfoDTO) -> Bool {
        return
            lhs.vendorId == rhs.vendorId &&
            lhs.advertTrackingEnabled == rhs.advertTrackingEnabled &&
            lhs.uniqueAppId == rhs.uniqueAppId &&
            lhs.localStorageId == rhs.localStorageId
    }
}
