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

struct RSdkContactInfo {
    
    internal static var accessContacts : Bool {
        
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
    private static var rSdkContactStores : [ContactStoreDTO] {
    
        var resultContainers = [ContactStoreDTO]()
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey ] as [Any]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch let error {

            guard let _snippetId = RSdkRequestInfoManager.sharedRequestInfoManager._snippetId, let requestToken = RSdkRequestInfoManager.sharedRequestInfoManager._token else {
                
                let dataError = RSdkErrorType.missingData
                RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: dataError), completion: { (_, _) in
                    
                })
                
                return []                
            }
            
            let contactError = RSdkErrorType.contactStore(_snippetId, requestToken, error.localizedDescription)
            RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: contactError), completion: { (_, _) in
                
            })
            
            return []
        }

        // Iterate all containers and append their contacts to our results array
        for container in allContainers {

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
                    resultContainers.append(newContactStore)
                }
            } catch let error as NSError {
                
                guard let _snippetId = RSdkRequestInfoManager.sharedRequestInfoManager._snippetId, let _requestToken = RSdkRequestInfoManager.sharedRequestInfoManager._token else {
                    
                    let _dataError = RSdkErrorType.missingData
                    RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: _dataError), completion: { (_, _) in
                        
                    })
                    
                    return []
                }
                
                let contactError = RSdkErrorType.contactStore(_snippetId, _requestToken, error.debugDescription)
                RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: contactError), completion: { (_, _) in
                    
                })
                
                return []
            }
        }
        return resultContainers
    }
    
    internal static var conctactStores : [ContactStoreDTO] {

        if #available(iOS 9, *) {
            if accessContacts {
                
                return rSdkContactStores
            }
            return []
        }
        return []
    }
    
}
