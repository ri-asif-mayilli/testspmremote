//
//  CellularDTOIOS12.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 04.10.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation
//struct CellularDTOIOS12 : Codable {
//
//    let accessTechnology = RSdkCellularInfoIOS12.celluarInfoCurrentAccessTechnology
//    let carrier = CarrierDTOIOS12()
//}
//
//
//struct CarrierDTOIOS12 : Codable {
//    let names:[String]?              =  RSdkCarrierInfoIOS12.carrierInfoName
//    let countryCodes : [String]?     = RSdkCarrierInfoIOS12.carrierInfoCountryCode
//    let mobileCountryCodes:[String]? = RSdkCarrierInfoIOS12.carrierInfoCountryCode
//    let mobileNetworkCodes:[String]? = RSdkCarrierInfoIOS12.carrierInfoNetworkCode
//    let isoCountryCodes  :[String]?  = RSdkCarrierInfoIOS12.carrierInfoIsoCountryCode
//    let allowsVoips   :[Bool]?    = RSdkCarrierInfoIOS12.carrierInfoAllowsVoip
//}

#if !targetEnvironment(macCatalyst)
struct CellularDTOIOS12 : Codable {
    let accessTechnology:[String]?
    let carrier:CarrierDTOIOS12
    
    
    init(){
        self.accessTechnology = RSdkCellularInfoIOS12.celluarInfoCurrentAccessTechnology
        self.carrier = CarrierDTOIOS12()
    }
    
    init(accessTechnology:[String],carrier:CarrierDTOIOS12){
        self.accessTechnology = accessTechnology
        self.carrier = carrier
    }
}


struct CarrierDTOIOS12 : Codable {
    
    let name:[String]?
    let countryCode:[String]?
    let mobileCountryCode:[String]?
    let mobileNetworkCode:[String]?
    let isoCountryCode:[String]?
    let allowsVoip:[Bool]?
    
    init(){
        self.name = RSdkCarrierInfoIOS12.carrierInfoName
        self.countryCode = RSdkCarrierInfoIOS12.carrierInfoCountryCode
        self.mobileCountryCode = RSdkCarrierInfoIOS12.carrierInfoCountryCode
        self.mobileNetworkCode = RSdkCarrierInfoIOS12.carrierInfoNetworkCode
        self.isoCountryCode = RSdkCarrierInfoIOS12.carrierInfoIsoCountryCode
        self.allowsVoip = RSdkCarrierInfoIOS12.carrierInfoAllowsVoip
    }
    
    init(name:[String],countryCode:[String],mobileCountryCode:[String],mobileNetworkCode:[String],isoCountryCode:[String],allowsVoip:[Bool]){
        self.name = name
        self.countryCode = countryCode
        self.mobileCountryCode = mobileCountryCode
        self.mobileNetworkCode = mobileNetworkCode
        self.isoCountryCode = isoCountryCode
        self.allowsVoip = allowsVoip
    }
    
}

extension CellularDTOIOS12: Equatable {
    public static func ==(lhs: CellularDTOIOS12, rhs: CellularDTOIOS12) -> Bool {
        return
            lhs.accessTechnology == rhs.accessTechnology &&
            lhs.carrier == rhs.carrier
    }
}

extension CarrierDTOIOS12: Equatable {
    public static func ==(lhs: CarrierDTOIOS12, rhs: CarrierDTOIOS12) -> Bool {
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
