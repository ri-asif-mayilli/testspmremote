//
//  HTTPProtocol.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 31.08.17.
//  Copyright © 2017 RISK.IDENT GMBH. All rights reserved.
//

import Foundation

public class HTTPProtocol {
    
    public class func post() {
        
        DeviceDTOFactory.create(completion: { (device) in
            
            postBin(device: device)
        })
    }
    
    private class func postBin(device : DeviceDTO) {
        
        DispatchQueue.global(qos: .userInteractive).async {
        
            RequestManager.shared.doRequest(requestType: .postBin(deviceDTO: device)) {
                
                (data, error) in
                
                if let error = error {
                    
                    print(error)
                }
                
                if let data = data {
           
                    do {
   
                        let jsonResult = try JSONSerialization.jsonObject(with: data)
                        print(jsonResult) //this part works fine
                
                    } catch let error {
                        
                        print(error)
                    }
                }
            }
        }
    }
    
    public class func getBrowserInfo(fromToken token: String, completion: ((BrowserDTO?, Error?) -> Void)?) {
        
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
                        
                        var browserInfo = try decoder.decode(BrowserDTO.self, from: data)
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


