//
//  Browser.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 31.08.17.
//  Copyright © 2017 RISK.IDENT GMBH. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import MapKit

public class ClientSecurityModule : NSObject {
    
    var wkWebView = WKWebView()
    var _token : String?
    
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
    
    
    /// This is the Client Security Module.
    ///
    /// Usage:
    ///
    /// Just init the Module and store locally the refernce to it globally.
    ///
    /// - Parameters:
    ///   - snippetId: String -> The snippet id
    ///   - uniqueId: String -> A Unique execution UUID for the Call.
    ///   - fromLocation: String -> String for ?
    ///   - enableLocationFinder: Bool -> Enable Location Finding. Default: false
    ///   - geoLocation: CLLocation -> Class with the user location.
    public init(snippetId: String, requestToken: String, fromLocation: String? = nil, enableLocationFinder: Bool = false, geoLocation: CLLocation? = nil) {
    
        super.init()
        uuidToken = requestToken
        wkWebView.navigationDelegate = self
        execute(snippetId: snippetId, location: fromLocation)
        RSdkHTTPProtocol.postDeviceData(_snippetId: snippetId, _requestToken: requestToken, _location: fromLocation, _enableLoactionFinder: enableLocationFinder, _geoLocation: geoLocation) {
            
            (error) in
        }
        
        let _ = Obfuscator.sharedObfuscator.bytesByObfuscatingString(string: "/Applications/Cydia.app")
        let _ = Obfuscator.sharedObfuscator.bytesByObfuscatingString(string: "/Library/MobileSubstrate/MobileSubstrate.dylib")
        let _ = Obfuscator.sharedObfuscator.bytesByObfuscatingString(string: "/bin/bash")
        let _ = Obfuscator.sharedObfuscator.bytesByObfuscatingString(string: "/usr/sbin/sshd")
        let _ = Obfuscator.sharedObfuscator.bytesByObfuscatingString(string: "/etc/apt")
        let _ = Obfuscator.sharedObfuscator.bytesByObfuscatingString(string: "/private/var/lib/apt")
    }
    
    private func execute(snippetId: String, location: String?) {
        
        guard let request = createRequest(snippetId: snippetId, token: uuidToken, location: location), let _ = request.url else { return }
        
        wkWebView.load(request)
    }

    private func createRequest(snippetId: String, token: String, location: String?) -> URLRequest? {
        
        let urlString = "\(RSdkVars.SNIPPET_ENDPOINT)\(snippetId)?t=\(token)&l=\(location ?? "")"
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
}

extension ClientSecurityModule : WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        print("Webrequest Fail")
    }    
}
