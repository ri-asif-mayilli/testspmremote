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
    var completion : (String, Error?) -> Void
    
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
    public init(snippetId: String, token: String?, location: String? = nil, completion: @escaping (String, Error?) -> Void) {
    
        self.completion = completion
        super.init()
        if let token = token {
            
            uuidToken = token
        } else {
            
            uuidToken = UUID().uuidString
        }
    
        
        wkWebView.navigationDelegate = self
        execute(snippetId: snippetId, location: location)
    }
    
    private func execute(snippetId: String, location: String?) {
        
        guard let request = createRequest(snippetId: snippetId, token: uuidToken, location: location), let url = request.url else { return }
        
        print("Load Snippet: \(url)")
        print("used uuid: \(uuidToken)")
        wkWebView.load(request)
    }

    private func createRequest(snippetId: String, token: String, location: String?) -> URLRequest? {
        
        let urlString = "/(RSdkVars.SNIPPET_ENDPOINT)/\(snippetId)?t=\(token)&l=\(location ?? "")"
        print(urlString)
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
}

extension RSdkBrowser : WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        print("did start")
    }
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print(challenge)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("finsih")
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    
        print(error)
    }
    
}
