/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
//
//  ContactInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 12.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import Contacts
import AddressBook
import UIKit

class RSdkContactInfo {
    var throwable:Bool = true
    var errors:[String] = []
    internal var accessContacts : Bool {
        
        if #available(iOS 9, *) {
            return CNContactStore.authorizationStatus(for: CNEntityType.contacts) == .authorized
        } else {
            return false
        }
    }
    
    @available(iOS 9, *)
    func getContainers(contactStore: CNContactStore) -> [CNContainer]{
        
        do {
            let allContainers = try contactStore.containers(matching: nil)
            return allContainers
        } catch let error as NSError {
            errors.append(error.debugDescription)
            return []
        }
    }
    
    
    @available(iOS 9, *)
    private var rSdkContactStores : [ContactStoreDTO] {
    
        var resultContainers = [ContactStoreDTO]()
        let contactStore = CNContactStore()
        // Get all the containers
        let allContainers: [CNContainer] = getContainers(contactStore: contactStore)
        

        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            if let formatedContainer = formatContainer(container: container, contactStore: contactStore){
                resultContainers.append(formatedContainer)
            }
        }
        return resultContainers
    }
    
    
    @available(iOS 9.0, *)
    func formatContainer(container:CNContainer,contactStore:CNContactStore)->ContactStoreDTO?{
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey ] as [Any]
        let _identifier = container.identifier
        let _name = container.name
        let _type : String
        switch(container.type) {
            case .unassigned:
                _type = "unassigned"
            case .local:
                _type = "local"
            case .exchange:
                _type = "exchange"
            case .cardDAV:
                _type = "cardDav"
            default:
                _type = "unknown"
        }
        
        let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

        do {
            if let keys = keysToFetch as? [CNKeyDescriptor] {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keys)
                let newContactStore = ContactStoreDTO(_identifier, name: _name, type: _type, count: containerResults.count)
                return newContactStore
            }
        } catch let error as NSError {
            errors.append(error.debugDescription)
        }
        return nil
    }
    
    internal var conctactStores : [ContactStoreDTO] {
        if #available(iOS 9, *) {
            if accessContacts {
                return rSdkContactStores
            }
        }
        return []
    }
}
