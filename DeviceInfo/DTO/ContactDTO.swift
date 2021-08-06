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
    let contactCollector = RSdkContactInfo()
    
    private enum CodingKeys: String, CodingKey {
            case contactsStores, access
    }
    
    
    func errors() -> [String]{
        return self.contactCollector.errors
    }
    
    
    init(){
        self.access = contactCollector.accessContacts
        self.contactsStores = contactCollector.conctactStores
    }
    
    init(access:Bool,contactsStores:[ContactStoreDTO] ){
        self.access = access
        self.contactsStores = contactsStores
    }
}



struct ContactStoreDTO : Codable {
    
    let identifier : String
    let name : String
    let contactType : String
    let count : Int
    
    public init(_ identifier: String, name: String, type: String, count: Int) {
        
        self.identifier = identifier
        self.name = name
        self.contactType = type
        self.count = count
    }
}


extension ContactStoreDTO: Equatable {
    public static func ==(lhs: ContactStoreDTO, rhs: ContactStoreDTO) -> Bool {
        return
            lhs.identifier == rhs.identifier &&
            lhs.name == rhs.name &&
            lhs.contactType == rhs.contactType &&
            lhs.count == rhs.count
    }
}
extension ContactDTO: Equatable {
    public static func ==(lhs: ContactDTO, rhs: ContactDTO) -> Bool {
        return
            lhs.access == rhs.access &&
            lhs.contactsStores == rhs.contactsStores
    }
}
