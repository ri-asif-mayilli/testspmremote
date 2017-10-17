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
    
    
    /// This is the Client Security Module.
    ///
    /// Usage:
    ///
    /// Just init the Module and store locally the refernce to it globally.
    ///
    /// - Parameters:
    ///   - snippetId: String -> The snippet id
    ///   - uniqueId: String -> A Unique execution UUID for the Call.
    ///   - location: String -> String for ?
    ///   - enableLocationFinder: Bool -> Enable Location Finding. Default: false
    ///   - geoLocation: CLLocation -> Class with the user _location.
    public init(snippetId: String, token: String, location: String? = nil, enableLocationFinder: Bool = false, geoLocation: CLLocation? = nil) {
    
        super.init()
        uuidToken = token
        _snippetId = snippetId
        RSdkRequestInfoManager.sharedRequestInfoManager.setupManager(_token: token, _snippetId: snippetId)
        wkWebView.navigationDelegate = self
        execute(snippetId: snippetId, _location: location)
        RSdkHTTPProtocol.postDeviceData(_snippetId: snippetId, _requestToken: token, _location: location, _enableLoactionFinder: enableLocationFinder, _geoLocation: geoLocation) {
            
            (error) in
            
            if let error = error {
            
                RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .postNativeData(snippetId, token, error.localizedDescription))) {
                (_,_) in
                
                }
            }
        }
    }
    
    private func execute(snippetId: String, _location: String?) {
        
        guard let request = createRequest(snippetId: snippetId, token: uuidToken, _location: _location), let _ = request.url else { return }        
        wkWebView.load(request)
    }

    private func createRequest(snippetId: String, token: String, _location: String?) -> URLRequest? {
        
        let urlString = "\(RSdkVars.SNIPPET_ENDPOINT)\(snippetId)?t=\(token)&l=\(_location ?? "")"
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
}

extension ClientSecurityModule : WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        guard let snippet = _snippetId, let uuidToken = _token else { return }
        
        RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .executeWebSnippet(snippet, uuidToken, error.localizedDescription))) {
            (_,_) in
            
        }
    }    
}
