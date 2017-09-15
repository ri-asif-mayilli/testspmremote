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
    
    case requestScript(token : String)
    case postBin(deviceDTO : DeviceDTO)
    
    var payload : Data? {
        
        switch(self) {
            
        case .requestScript:
            return nil
            
        case .postBin(let payload):
        
            let encoder = JSONEncoder()
            do {
                let enc = try encoder.encode(payload)
                return enc
                
            } catch let error {
                
                print(error)
                return nil
            }
        }
    }
    
    var url : URL? {
        
        switch self {
            
        case .requestScript(let token):
            
            guard let url = URL(string: "https://demo-test-backup.jsctool.com/api/v4/transactions/bySite/ios-sdk-test/\(token)?include=all") else { return nil }
            return url
            
        case .postBin:
            let urlString = "\(Vars.POST_ENDPOINT)"
            guard let url = URL(string: urlString) else { return nil }
            return url
        }
    }
    
    var method : RequestMethod {
        
        switch self {
            
        case .requestScript:
            return .get
        case .postBin:
            return .post
        }
    }
    
    var authString : String? {
        
        switch self {
            
        case .requestScript:
            
            return generateAuthString(username: "ios-sdk-test", password: "geekios")
        case .postBin:
            return nil
            
        }
    }
    
    var retry : Bool {
        
        switch self {
            
        case .requestScript:
            return true
        case .postBin:
            return false
        }
        
    }
    
    private func generateAuthString(username : String, password : String) -> String {
        
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return loginData.base64EncodedString()
    }
}

public class RequestManager {
    
    static let shared = RequestManager()
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
            }
            
            if let response = response as? HTTPURLResponse {
                
                switch requestType {
                    
                case .requestScript:
                    
                    if response.statusCode == 404 {
                        
                        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 5) {
                            
                            self.doRequest(requestType: requestType, completion: completion)
                        }
                        return
                    }
                    
                default:
                    break
                }
                
                if let data = data {
                    
                    if let url = requestType.url {
                        
                        print("Fetched transaction result: \(url)")
                    }
                    
                    completion(data, nil)
                }
            }
        }
        task?.resume()
    }
    
}

