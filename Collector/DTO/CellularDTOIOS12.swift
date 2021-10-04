//
//  CellularDTOIOS12.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 04.10.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation


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
    
    let names:[String]?
    let countryCodes:[String]?
    let mobileCountryCodes:[String]?
    let mobileNetworkCodes:[String]?
    let isoCountryCodes:[String]?
    let allowsVoips:[Bool]?
    
    init(){
        self.names = RSdkCarrierInfoIOS12.carrierInfoName
        self.countryCodes = RSdkCarrierInfoIOS12.carrierInfoCountryCode
        self.mobileCountryCodes = RSdkCarrierInfoIOS12.carrierInfoCountryCode
        self.mobileNetworkCodes = RSdkCarrierInfoIOS12.carrierInfoNetworkCode
        self.isoCountryCodes = RSdkCarrierInfoIOS12.carrierInfoIsoCountryCode
        self.allowsVoips = RSdkCarrierInfoIOS12.carrierInfoAllowsVoip
    }
    
    init(name:[String],countryCode:[String],mobileCountryCode:[String],mobileNetworkCode:[String],isoCountryCode:[String],allowsVoip:[Bool]){
        self.names = name
        self.countryCodes = countryCode
        self.mobileCountryCodes = mobileCountryCode
        self.mobileNetworkCodes = mobileNetworkCode
        self.isoCountryCodes = isoCountryCode
        self.allowsVoips = allowsVoip
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
            lhs.names == rhs.names &&
            lhs.countryCodes == rhs.countryCodes &&
            lhs.mobileCountryCodes == rhs.mobileCountryCodes &&
            lhs.mobileNetworkCodes == rhs.mobileNetworkCodes &&
            lhs.isoCountryCodes == rhs.isoCountryCodes &&
            lhs.allowsVoips == rhs.allowsVoips
    }
}
#endif
