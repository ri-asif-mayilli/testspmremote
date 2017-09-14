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

public class Browser : NSObject {
    
    var wkWebView = WKWebView()
    var _token : String?
    var completion : (BrowserDTO?, Error?) -> Void
    
    public var uuidToken : String {
        
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
    
    public init(uuid: String, completion: @escaping (BrowserDTO?, Error?) -> Void) {
        
        _token = uuid
        self.completion = completion
        super.init()
        wkWebView.navigationDelegate = self
        execute()
    }
    
    public func execute() {
        
        guard let request = createRequest2(uuidToken), let url = request.url else { return }
        
        print("Load Snippet: \(url)")
        print("used uuid: \(uuidToken)")
        wkWebView.load(request)
    }
    
    public static func loadScript(fromUIWebView webView : UIWebView, token: String) {
        
        guard let request = createRequest(token) else { return }
        webView.loadRequest(request)
    }
    
    public static func loadScript(fromWKWebView webView: WKWebView, token: String) {
        
        guard let request = createRequest(token) else { return }
        webView.load(request)
    }
    
    private static var authBase64 : String {
        
        let username = "ios-sdk-test"
        let password = "geekios"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return loginData.base64EncodedString()
    }
    
    private var authBase : String {
        
        let username = "ios-sdk-test"
        let password = "geekios"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return loginData.base64EncodedString()
    }
    
    private static func createRequest(_ token: String) -> URLRequest? {
        
        let urlString = "https://mobile-test-backup.jsctool.com/ios-sdk-test?serverPush=false&t=\(token)"
        
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.setValue("Basic \(authBase64)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func createRequest2(_ token: String) -> URLRequest? {
        
        let urlString = "https://mobile-test-backup.jsctool.com/ios-sdk-test?serverPush=false&t=\(token)"
        
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.setValue("Basic \(authBase)", forHTTPHeaderField: "Authorization")
        return request
    }
}

extension Browser : WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        HTTPProtocol.getBrowserInfo(fromToken: uuidToken, completion: completion)
    }
    
}
