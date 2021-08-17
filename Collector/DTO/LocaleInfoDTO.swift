//
//  LocaleInfoDTO.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 08.06.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation
internal struct LocaleInfoDTO : Codable {
    
    let preferredLanguages:[String]
    let timeZone:String
    
    init(){
        self.preferredLanguages = RSdkLocaleInfo.localeInfoPreferredLanguages
        self.timeZone = RSdkLocaleInfo.localeInfoLocalTimeZone
    }
    
    init(preferredLanguages:[String],timeZone:String) {
        self.preferredLanguages = preferredLanguages
        self.timeZone = timeZone
    }
}

extension LocaleInfoDTO: Equatable {
    public static func ==(lhs: LocaleInfoDTO, rhs: LocaleInfoDTO) -> Bool {
        return
            lhs.preferredLanguages == rhs.preferredLanguages &&
            lhs.timeZone == rhs.timeZone
    }
}
