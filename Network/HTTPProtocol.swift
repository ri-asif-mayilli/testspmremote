//
//  HTTPProtocol.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 31.08.17.
//  Copyright © 2017 RISK.IDENT GMBH. All rights reserved.
//

import Foundation

public class HTTPProtocol {
    
    public class func getBrowserInfo(fromToken token: String, completion: ((BrowserInfo?, Error?) -> Void)?) {
        
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 0) {
            
            RequestManager.shared.doRequest(requestType: .requestScript(token: token)) {
                
                (data, error) in
                if let error = error {
                    
                    if let completion = completion {
                        
                        completion(nil, error)
                        return
                    }
                }
                if let data = data {
                    
                    let decoder = JSONDecoder()
                    do {
                        
                        var browserInfo = try decoder.decode(BrowserInfo.self, from: data)
                        browserInfo.transactionDate = Date()
                        if let completion = completion {
                            
                            completion(browserInfo, nil)
                            return
                        }
                        
                    } catch let error {
                        
                        if let completion = completion {
                            
                            completion(nil, error)
                            return
                        }
                    }
                    
                }
            }
        }
    }
}


