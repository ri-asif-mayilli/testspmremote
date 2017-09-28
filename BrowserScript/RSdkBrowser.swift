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

public class RSdkBrowser : NSObject {
    
    var wkWebView = WKWebView()
    var _token : String?
    var completion : (RSdkBrowserDTO?, Error?) -> Void
    
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
    
    
    /// This is the Browser Class which Execute the Web Snippet.
    ///
    /// - Parameters:
    ///   - uuid: String -> A Unique execution UUID for the Call.
    ///   - action: String -> Action Description for the Execution (e.g. checkout)
    ///   - completion: -> (BrowserDTO, Error) Callback with BrowserDTO Data or an Error if anything failed.
    public init(uuid: String, action: String, completion: @escaping (RSdkBrowserDTO?, Error?) -> Void) {
        
        _token = uuid
        self.completion = completion
        super.init()
        wkWebView.navigationDelegate = self
        execute()
    }
    
    private func execute() {
        
        guard let request = createRequest2(uuidToken), let url = request.url else { return }
        
        print("Load Snippet: \(url)")
        print("used uuid: \(uuidToken)")
        wkWebView.load(request)
    }
    
    private static func loadScript(fromUIWebView webView : UIWebView, token: String) {
        
        guard let request = createRequest(token) else { return }
        webView.loadRequest(request)
    }
    
    private static func loadScript(fromWKWebView webView: WKWebView, token: String) {
        
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
        
        let urlString = "https://mobile-backup-test.jsctool.com/ios-sdk-test?serverPush=false&t=\(token)"
        
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.setValue("Basic \(authBase64)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func createRequest2(_ token: String) -> URLRequest? {
        
        let urlString = "https://mobile-backup-test.jsctool.com/ios-sdk-test?serverPush=false&t=\(token)"
        
//        https://mobile-backup-test.jsctool.com/testsite
        
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.setValue("Basic \(authBase)", forHTTPHeaderField: "Authorization")
        return request
    }
}

extension RSdkBrowser : WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("didFinish web call")
        RSdkHTTPProtocol.getBrowserInfo(fromToken: uuidToken, completion: completion)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    
        print(error)
    }
    
}
