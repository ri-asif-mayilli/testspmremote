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
    
    var value : String {
        
        switch(self) {
            
        case .post:
            return "POST"
            
        case .get:
            return "GET"
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
                
            } catch let error {
                
//                print(error)
                return nil
            }
        }
    }
    
    var url : URL? {
        
        switch self {
            
        case .postBin:
            let urlString = "\(RSdkVars.POST_ENDPOINT)"
            guard let url = URL(string: urlString) else { return nil }
            return url
        }
    }
    
    var method : RequestMethod {
        
        switch self {
            
        case .postBin:
            return .post
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
    
    static let shared = RSdkRequestManager()
    private init() {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        self.session = session
    }
    
    let session : URLSession?
    
    private func createRequest(requestType : RequestManagerType) -> URLRequest? {
        
        guard let url = requestType.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = requestType.method.value
        if let authString = requestType.authString {
            
            request.setValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
        }
        
        if let payload = requestType.payload {

            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("x-di-b", forHTTPHeaderField: "Content-Encoding")
            request.httpBody = payload
        }
        
        return request
    }
    
    func doRequest(requestType : RequestManagerType, completion: @escaping RequestCompletionHandler) {
        
        guard let request = createRequest(requestType: requestType) else {
        
            completion(nil, NSError(domain: "Postbin", code: 666, userInfo: nil))
            return
            
        }
        let task = session?.dataTask(with: request) {
            
            (data, response, error) in
            
            if let error = error {
                
                completion(nil, error)
                return
            }
            completion(nil,nil)
        }
        task?.resume()
    }
    
}

