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
    
    case postClientBin(deviceDTO : RSdkDeviceDTO)
    case postBin(deviceDTO : RSdkDeviceDTO)
    case postError(error : RSdkErrorType)
    
    var payload : Data? {
        
        switch(self) {
            
        case .postBin(let payload):
        
            let encoder = JSONEncoder()
            do {
                let enc = try encoder.encode(payload).base64EncodedData()
                return enc
                
            } catch let error as NSError {
   
                RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .encodeNativeData(payload.snippetId, payload.token, error.debugDescription))) {
                    (_,_) in
                    
                }
                return nil
            }
        case .postClientBin(let payload):
            let encoder = JSONEncoder()
            do {
                let enc = try encoder.encode(payload).base64EncodedData()
                return enc
                
            } catch let error as NSError {
                
                RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .encodeNativeData(payload.snippetId, payload.token, error.debugDescription))) {
                    (_,_) in
                    
                }
                return nil
            }
            
        
        case .postError(let error):
        
            let encoder = JSONEncoder()
            do {
                let dto = RSdkErrorDTO(error)
                let enc = try encoder.encode(dto).base64EncodedData()
                return enc
                
            } catch {
                
                return nil
            }
        }
    }
    
    var url : URL? {
        
        switch self {
            
        case .postBin(let payload):
            
            let urlString = "\(RSdkVars.POST_ENDPOINT)\(payload.snippetId)\(RSdkVars.ENDPOINT_ADDITIONAL)\(payload.token)"
            guard let url = URL(string: urlString) else {
                RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .domainError("Not valid Domain: \(urlString)")), completion: { (_, _) in
                    
                })
                return nil
            }
            return url
        
        case .postClientBin(let payload):
            let urlString = "\(RSdkVars.CLIENT_DATA_ENDPOINT)?t=\(payload.token)"
            guard let url = URL(string: urlString) else {
                RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .domainError("Not valid Domain: \(urlString)")), completion: { (_, _) in
                    
                })
                return nil
            }
            return url
        
        case .postError(let error):

            let urlString = "\(RSdkVars.ERROR_ENDPOINT)\(error._snippetId)\(RSdkVars.ENDPOINT_ADDITIONAL)\(error._requestToken)"
            guard let url = URL(string: urlString) else { return nil }
            return url
        }
    }
    
    var method : RequestMethod {
        
        switch self {
            
        case .postBin:
            return .put
    
        case .postClientBin:
            return .post
            
        case .postError:
            return .put
        
        }
    }
    
    var authString : String? {
        
        switch self {
            
        case .postBin:
            return nil
        case .postClientBin:
            return nil
        case .postError:
            return nil
        }
    }
    
    var retry : Bool {
        
        switch self {

        case .postBin:
            return false
            
        case .postClientBin:
            return false
            
        case .postError:
            return false
        }
        
    }
}

internal class RSdkRequestManager {
    
    static let sharedRequestManager = RSdkRequestManager()
    private init() {
        
        let _configuration = URLSessionConfiguration.default
        _configuration.timeoutIntervalForRequest = 60 * 30 //30 Minutes
        _configuration.timeoutIntervalForResource = 60 * 30 //30 Minutes
        let _session = URLSession(configuration: _configuration)
        self.rsdkRequestSession = _session
    }
    
    let rsdkRequestSession : URLSession?
    
    private func createRequest(requestType : RequestManagerType) -> URLRequest? {
        
        guard let url = requestType.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = requestType.method.value
        
        switch requestType{
            case .postClientBin(let deviceData):
                let encoder = JSONEncoder()
                do {
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    
                    let customArgsFormatted = customArgsToString(customArgs: RSdkRequestInfoManager.sharedRequestInfoManager._customArgs)
                    
                    let parameters: [String: Any] = [
                        "v": deviceData.snippetId,
                        "l": deviceData._location,
                        "d": try encoder.encode(deviceData).base64EncodedString(),
                        "va": customArgsFormatted
                    ]
                    let body = joinMapToString(map: parameters)
                    
                    request.httpBody = body.data(using:String.Encoding.utf8, allowLossyConversion: true)
                    
                } catch let error as NSError {
                    
                    RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .encodeNativeData(deviceData.snippetId, deviceData.token, error.debugDescription))) {
                        (_,_) in
                        
                    }
                    return nil
                }

            
            default:
                if let payload = requestType.payload {
                    request.setValue(RSdkVars.RequestManagerVars.encodingType, forHTTPHeaderField: RSdkVars.RequestManagerVars.encodingHeaderType)
                    request.setValue(RSdkVars.RequestManagerVars.xdib, forHTTPHeaderField: RSdkVars.RequestManagerVars.xdibContentEncoding)
                    request.httpBody = payload
                }
        }

        return request
    }
    
    private func joinMapToString(map: [String : Any]) -> String {
        return map.map{ (key,value) in return "\(key)=\(value)" }.joined(separator: "&")
    }
    
    private func customArgsToString(customArgs: [String:String]) -> String {
        let customAllowedSet = NSCharacterSet(charactersIn:"=\"#%/<>?@\\^`{|}&").inverted
        let customArgsJoined = joinMapToString(map: customArgs)
        guard let encodedArgs = (customArgsJoined.addingPercentEncoding(withAllowedCharacters:customAllowedSet)) else {
            return customArgsJoined
        }
        return encodedArgs
    }
    
    func doRequest(requestType : RequestManagerType, completion: @escaping RequestCompletionHandler) {
        
        guard let request = createRequest(requestType: requestType) else {
        
            completion(nil, NSError(domain: "", code: 666, userInfo: nil))
            return
            
        }
        let task = rsdkRequestSession?.dataTask(with: request) {(data, response, error) in
            
            if let error = error as NSError? {
                //print(error)
                switch requestType {
                case .postError:
                    return
                case .postBin:
                    completion(nil, error)
                    return
                case .postClientBin:
                    completion(nil, error)
                    return
                }
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    completion(nil,NSError(domain: "http status \(response.statusCode)", code: 666, userInfo: nil))
                    return
                }
            }
            completion(nil, nil)
        }
        task?.resume()
    }
    
}

