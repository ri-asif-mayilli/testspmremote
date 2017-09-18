//
//  HTTPProtocol.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 31.08.17.
//  Copyright © 2017 RISK.IDENT GMBH. All rights reserved.
//

import Foundation
import CoreLocation

public class HTTPProtocol {
    
    
    /// Post Native iOS Data to Risk Ident Backend
    ///
    /// - Parameters:
    ///   - requestToken: String : The Token for the Request
    ///   - customerID: String : The Token for the customer
    ///   - enableLocationFinder: Bool -> Enable Location Finder, Default is false (WIP)
    ///   - location : CLLocation -> Give the User Location to the Framework. Default ist nil (WIP)
    ///   - completion: (Error) -> Void : Completion Handler which give Back Error to App (Error)
    public class func post(_ requestToken: String, customerID: String, enableLoactionFinder: Bool = false, location: CLLocation? = nil, completion: (Error) -> Void) {
        
        DeviceDTOFactory.create(requestToken, customerID: customerID, completion: { (device) in
            
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
    
    
    /// Parameter to execute Browser Snippet and get back BrowserDTO to App
    ///
    /// - Parameters:
    ///   - token: String Token for the Request
    ///   - completion: (BrowserDTO?, Error) -> Void : Completion which gives back the BrowserDTO or an Error if Exist.
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


