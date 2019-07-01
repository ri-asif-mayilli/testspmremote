//
//  Browser.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 31.08.17.
//  Copyright © 2017 RISK.IDENT GMBH. All rights reserved.
//

import Foundation
import UIKit

public class ClientSecurityModule : NSObject {
    
    var _token : String?
    var _snippetId : String?

    fileprivate var uuidToken : String {
        
        get {
            
            if let _token = _token {
                
                return _token
            } else {
                
                _token = UUID().uuidString
                return _token!
            }
        }
        
        set (newToken) {
            
            _token = newToken
        }
    }
    
    
    internal override init() {
        
    }
    
    @available(*, deprecated)
    @objc public init(snippetId: String, token: String, domain: String? = nil, location: String? = nil,view: UIView, customArgs: [ String : String ]? = nil) {
        super.init()
        uuidToken = token
        _snippetId = snippetId

        initializeRDskRequest(domain: domain, location: location, customArgs: customArgs)
    }

    /// This is the Client Security Module.
    ///
    /// Usage:
    ///
    /// Just init the Module and store locally the refernce to it globally.
    ///
    /// - Parameters:
    ///   - snippetId: String -> The snippet id
    ///   - token: String -> A Unique execution UUID for the Call.
    ///   - location: String -> String for ?
    ///   - domain: String -> An custom Domain
    ///   - customArgs: [ String : String ] -> Dictionary of Strings. Default: nil
    @objc public init(snippetId: String, token: String, domain: String? = nil, location: String? = nil,customArgs: [ String : String ]? = nil) {
    
        super.init()
        uuidToken = token
        _snippetId = snippetId

        initializeRDskRequest(domain: domain, location: location, customArgs: customArgs)
    }
    
    private func initializeRDskRequest(domain: String? = nil, location: String? = nil, customArgs: [ String : String ]? = nil) {
        guard let snippetId = _snippetId else {
            return
        }

        RSdkRequestInfoManager.sharedRequestInfoManager.setupManager(_token: uuidToken, _snippetId: snippetId, _domain: domain)
        
        RSdkHTTPProtocol.postDeviceData(_snippetId: snippetId, _token: uuidToken, _location: location, _mobileSdkVersion: RSdkRequestInfoManager.sharedRequestInfoManager._diMobileSdkVersion) {
            
            (error) in
            
            if let error = error as NSError? {
                
                RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .postNativeData(snippetId, self.uuidToken, error.debugDescription))) {
                    (_,_) in
                    
                }
            } else {
                self.doExecute(_snippetId: snippetId, _location: location, _customArgs: customArgs)
            }
        }
    }
    
    internal func doExecute(_snippetId: String, _location: String?, _customArgs: [String : String]?) {
        
        guard let request = createRequest(_snippetId: _snippetId, _token: uuidToken, _location: _location, _customArgs: _customArgs), let _ = request.url else { return }
        
    }

    internal func createRequest(_snippetId: String, _token: String, _location: String?, _customArgs: [String : String]?) -> URLRequest? {
        
        
        var urlStringBuild = "\(RSdkVars.SNIPPET_ENDPOINT)\(_snippetId)?t=\(_token)"
        
        if let _location = _location, !_location.isEmpty {
            
            urlStringBuild = "\(urlStringBuild)&l=\(_location)"
        }
        
        let urlString : String
        if let _customArgs = _customArgs {
            
            urlString = addCustomArgs(urlStringBuild, _customArgs: _customArgs)

        } else {
            
            urlString = urlStringBuild
        }
        
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
    internal func addCustomArgs(_ urlString : String, _customArgs: [String : String]) -> String {
       
        var first = true
        var _customArgsString = ""
        for (_key, _value) in _customArgs {
            
            if let key = _key.htmlEncoded, let value = _value.htmlEncoded {
            
                if first {
                    first = !first
                    _customArgsString = "\(key)=\(value)"
                } else {
                    
                    _customArgsString = "\(key)=\(value)&\(_customArgsString)"
                }
            }
        }

        if let encodedCustomArgs = _customArgsString.htmlEncoded {
            
            return "\(urlString)&va=\(encodedCustomArgs)"
        } else {
            return urlString
        }
    }
}
