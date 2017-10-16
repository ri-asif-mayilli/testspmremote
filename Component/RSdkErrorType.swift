//
//  RSdkError.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 16.10.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation

internal enum RSdkErrorType {
    
    case encodeNativeData(String, String, String)
    case postNativeData(String, String, String)
    case executeWebSnippet(String, String, String)
    case getSystemData(String, String, String)
    
    var code : Int {
        
        switch(self) {
            
        case .encodeNativeData(_, _, _):
            return 1
            
        case .postNativeData(_, _, _):
            return 2
            
        case .executeWebSnippet(_, _, _):
            return 3
            
        case .getSystemData(_, _, _):
            return 4
        }
    }

    var snippetId : String {
    
        switch(self) {
        
        case .encodeNativeData(let value,_,_):
            return value
        
        case .postNativeData(let value,_,_):
            return value
            
        case .executeWebSnippet(let value,_,_):
            return value
            
        case .getSystemData(let value,_,_):
            return value
        }
    }
    
    var requestToken : String {
        
        switch(self) {

        case .encodeNativeData(_, let value,_):
            return value
            
        case .postNativeData(_, let value,_):
            return value
            
        case .executeWebSnippet(_, let value,_):
            return value
            
        case .getSystemData(_, let value,_):
            return value
        }
    }
    
    var description : String {

        switch(self) {
        case .encodeNativeData(_,_, let value):
        return value
        
        case .postNativeData(_,_, let value):
        return value
        
        case .executeWebSnippet(_,_, let value):
        return value
        
        case .getSystemData(_,_, let value):
        return value
        }
    }
}
