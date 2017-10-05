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

struct RSdkContactInfo {
    
    internal static var access : Bool {
        
        if #available(iOS 9, *) {
            return permission
        } else {
            return false
        }
    }
    
    @available(iOS 9, *)
    private static var permission : Bool {
        
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch(authorizationStatus) {
            
        case .authorized:
            return true
            
        default:
            return false
        }
    }
    
    @available(iOS 9, *)
    private static var contacts : [ContactStoreDTO] {
    
        var resultContainers = [ContactStoreDTO]()
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey ] as [Any]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
//            print("Error fetching containers")
        }
        
        var results: [CNContact] = []

        // Iterate all containers and append their contacts to our results array
        for container in allContainers {

            let identifier = container.identifier
            let name = container.name
            let type : String
            switch(container.type) {
                
            case .unassigned:
                type = "unassigned"
            case .local:
                type = "local"
            case .exchange:
                type = "exchange"
            case .cardDAV:
                type = "cardDav"
            }
            
            
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
                
                let newContactStore = ContactStoreDTO(identifier, name: name, type: type, count: containerResults.count)
                resultContainers.append(newContactStore)
            } catch {
//                print("Error fetching results for container")
            }
        }
        return resultContainers
    }
    
    internal static var conctactStores : [ContactStoreDTO] {

        if #available(iOS 9, *) {
            if access {
                return contacts
            }
            return []
        }
        return []
    }
    
}
