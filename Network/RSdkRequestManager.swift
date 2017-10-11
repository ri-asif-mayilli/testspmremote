//
//  RequestManager.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 31.08.17.
//  Copyright © 2017 RISK.IDENT GMBH. All rights reserved.
//

import Foundation

typealias RequestCompletionHandler = (Data?, Error?) -> Void

enum RequestMethod : String {
    
    case post
    case get
    case put
    
    var value : String {
        
        switch(self) {
            
        case .post:
            
            return "POST"
        case .get:
            
            return "GET"
        case .put:
            
            return "PUT"
        }
        
    }
}


enum RequestManagerType {
    
    case postBin(deviceDTO : RSdkDeviceDTO)
    
    var payload : Data? {
        
        switch(self) {
            
        case .postBin(let payload):
        
            let encoder = JSONEncoder()
            do {
                let enc = try encoder.encode(payload).base64EncodedData()
                return enc
                
            } catch {
                
//                print(error)
                return nil
            }
        }
    }
    
    var url : URL? {
        
        switch self {
            
        case .postBin(let payload):
            let urlString = "\(RSdkVars.POST_ENDPOINT)\(payload.snippetId)\(RSdkVars.ENDPOINT_ADDITIONAL)\(payload.token)"
            guard let url = URL(string: urlString) else { return nil }
            return url
        }
    }
    
    var method : RequestMethod {
        
        switch self {
            
        case .postBin:
            return .put
        }
    }
    
    var authString : String? {
        
        switch self {

        case .postBin:
            return nil
            
        }
    }
    
    var retry : Bool {
        
        switch self {

        case .postBin:
            return false
        }
        
    }
}

internal class RSdkRequestManager {
    
    static let sharedRequestManager = RSdkRequestManager()
    private init() {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        self.rsdkRequestSession = session
    }
    
    let rsdkRequestSession : URLSession?
    
    private func createRequest(requestType : RequestManagerType) -> URLRequest? {
        
        guard let url = requestType.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = requestType.method.value
        
        if let payload = requestType.payload {
            request.setValue(RSdkVars.RequestManagerVars.encodingType, forHTTPHeaderField: RSdkVars.RequestManagerVars.encodingHeaderType)
            request.setValue(RSdkVars.RequestManagerVars.xdib, forHTTPHeaderField: RSdkVars.RequestManagerVars.xdibContentEncoding)
            request.httpBody = payload
        }
        
        return request
    }
    
    func doRequest(requestType : RequestManagerType, completion: @escaping RequestCompletionHandler) {
        
        guard let request = createRequest(requestType: requestType) else {
        
            completion(nil, NSError(domain: "", code: 666, userInfo: nil))
            return
            
        }
        let task = rsdkRequestSession?.dataTask(with: request) {
            
            (data, response, error) in
            
            if let error = error {
                
                print("finish request with error \(error)")
                completion(nil, error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                
                if response.statusCode != 200 {
                    
                    print(response)
                }
            }
            
            completion(nil,nil)
        }
        task?.resume()
    }
    
}

