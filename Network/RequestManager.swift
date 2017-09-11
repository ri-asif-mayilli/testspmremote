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
    
    case POST
    case GET
}


enum RequestManagerType {
    
    case requestScript(token : String)
    
    var url : URL? {
        
        switch self {
            
        case .requestScript(let token):
            
            guard let url = URL(string: "https://demo-test-backup.jsctool.com/api/v4/transactions/bySite/ios-sdk-test/\(token)?include=all") else { return nil }
            return url
        }
    }
    
    var method : RequestMethod {
        
        switch self {
            
        case .requestScript:
            return .GET
        }
    }
    
    var authString : String? {
        
        switch self {
            
        case .requestScript:
            
            return generateAuthString(username: "ios-sdk-test", password: "geekios")
        }
    }
    
    var retry : Bool {
        
        switch self {
            
        case .requestScript:
            return true
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
        
        if let authString = requestType.authString {
            
            request.setValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func doRequest(requestType : RequestManagerType, completion: @escaping RequestCompletionHandler) {
        
        guard let request = createRequest(requestType: requestType) else { return }
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

