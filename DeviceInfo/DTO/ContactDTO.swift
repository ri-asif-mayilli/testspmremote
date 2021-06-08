//
//  ContactDTO.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 07.06.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation

struct ContactDTO : Codable {
    
    let access:Bool
    let contactsStores:[ContactStoreDTO]
    
    init(){
        self.access = RSdkContactInfo.accessContacts
        self.contactsStores = RSdkContactInfo.conctactStores
    }
    
    init(access:Bool,contactsStores:[ContactStoreDTO] ){
        self.access = access
        self.contactsStores = contactsStores
    }
}


extension ContactDTO: Equatable {
    public static func ==(lhs: ContactDTO, rhs: ContactDTO) -> Bool {
        return
            lhs.access == rhs.access &&
            lhs.contactsStores == rhs.contactsStores
    }
}
