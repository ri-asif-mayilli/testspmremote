//
//  CellularDTO.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 09.06.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation
#if !targetEnvironment(macCatalyst)
struct CellularDTO : Codable {
    let accessTechnology:String?
    let carrier:CarrierDTO
    
    
    init(){
        self.accessTechnology = RSdkCellularInfo.celluarInfoCurrentAccessTechnology
        self.carrier = CarrierDTO()
    }
    
    init(accessTechnology:String,carrier:CarrierDTO){
        self.accessTechnology = accessTechnology
        self.carrier = carrier
    }
}


struct CarrierDTO : Codable {
    
    let name:String?
    let countryCode:String?
    let mobileCountryCode:String?
    let mobileNetworkCode:String?
    let isoCountryCode:String?
    let allowsVoip:Bool?
    
    init(){
        self.name = RSdkCarrierInfo.carrierInfoName
        self.countryCode = RSdkCarrierInfo.carrierInfoCountryCode
        self.mobileCountryCode = RSdkCarrierInfo.carrierInfoCountryCode
        self.mobileNetworkCode = RSdkCarrierInfo.carrierInfoNetworkCode
        self.isoCountryCode = RSdkCarrierInfo.carrierInfoIsoCountryCode
        self.allowsVoip = RSdkCarrierInfo.carrierInfoAllowsVoip
    }
    
    init(name:String,countryCode:String,mobileCountryCode:String,mobileNetworkCode:String,isoCountryCode:String,allowsVoip:Bool){
        self.name = name
        self.countryCode = countryCode
        self.mobileCountryCode = mobileCountryCode
        self.mobileNetworkCode = mobileNetworkCode
        self.isoCountryCode = isoCountryCode
        self.allowsVoip = allowsVoip
    }
    
}

extension CellularDTO: Equatable {
    public static func ==(lhs: CellularDTO, rhs: CellularDTO) -> Bool {
        return
            lhs.accessTechnology == rhs.accessTechnology &&
            lhs.carrier == rhs.carrier
    }
}

extension CarrierDTO: Equatable {
    public static func ==(lhs: CarrierDTO, rhs: CarrierDTO) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.countryCode == rhs.countryCode &&
            lhs.mobileCountryCode == rhs.mobileCountryCode &&
            lhs.mobileNetworkCode == rhs.mobileNetworkCode &&
            lhs.isoCountryCode == rhs.isoCountryCode &&
            lhs.allowsVoip == rhs.allowsVoip
    }
}
#endif
