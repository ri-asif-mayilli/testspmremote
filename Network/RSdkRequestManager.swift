/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
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
    
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    
}


enum RequestManagerType {
    
    case postClientBin(deviceDTO : RSdkDeviceDTO)
    case postBin(deviceDTO : RSdkDeviceDTO)
    case postError(error : RSdkErrorType)
    case postCombinedErrors(error: RSDKNewErrorDTO)
    
    
    
    var payload : Data? {
        switch(self) {
        case .postBin(let payload):
            return setPayload(payload: payload) ?? nil
        case .postClientBin(let payload):
            return setPayload(payload: payload) ?? nil
        case .postError(let error):
            let encoder = JSONEncoder()
            do {
                let dto = RSdkErrorDTO(error)
                let enc = try encoder.encode(dto).base64EncodedData()
                return enc
            } catch {
                return nil
            }
            
        case .postCombinedErrors(let error):
            let encoder = JSONEncoder()
            do {
                let enc = try encoder.encode(error).base64EncodedData()
                return enc
            } catch {
                return nil
            }
        }
        
       
    }
    
    
    
    var url : URL? {
        switch self {
            
        case .postBin(let payload):
            return setUrl(endpoint: RSdkVars.HOST, endpointAdditional: RSdkVars.ENDPOINT_ADDITIONAL, payload: payload) ?? nil

        case .postClientBin(let payload):
            return setUrl(endpoint: RSdkVars.HOST, payload: payload) ?? nil
        
        case .postError(let error):

            let urlString = "\(RSdkVars.HOST)\(error._snippetId)\(RSdkVars.ENDPOINT_ADDITIONAL)\(error._requestToken)"
            guard let url = URL(string: urlString) else { return nil }
            return url
            
        case .postCombinedErrors(let error):

            let urlString = "\(RSdkVars.HOST)\(error.snippetId)\(RSdkVars.ENDPOINT_ADDITIONAL)\(error.token)"
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
            
        case .postError, .postCombinedErrors:
            return .put
        
        }
    }
    
    func setUrl(endpoint:String,endpointAdditional:String?=nil,payload:RSdkDeviceDTO)->URL?{
        var urlString = "\(endpoint)"
        if  let endpointAdditional = endpointAdditional {
            urlString = urlString + "\(payload.snippetId)\(endpointAdditional)\(payload.token)"
        }else{
            urlString = urlString + "?t=\(payload.token)"
        }
        
        guard let url = URL(string: urlString) else {
            RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .domainError("","","Not valid Domain: \(urlString)")))
            return nil
        }
        return url
    }
    
    func setPayload(payload:RSdkDeviceDTO)->Data?{
        let encoder = JSONEncoder()
        do {
            let enc = try encoder.encode(payload).base64EncodedData()
            return enc
            
        } catch let error as NSError {

            RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .encodeNativeData(payload.snippetId, payload.token, error.debugDescription)))
            return nil
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
        request.httpMethod = requestType.method.rawValue
        
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
                    
                    RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .encodeNativeData(deviceData.snippetId, deviceData.token, error.debugDescription))) 
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
    
    func doRequest(requestType : RequestManagerType, completion: RequestCompletionHandler? = nil) {
        
        guard let request = createRequest(requestType: requestType) else {
        
            completion!(nil, NSError(domain: "", code: 666, userInfo: nil))
            return
            
        }
        let task = rsdkRequestSession?.dataTask(with: request) {(data, response, error) in
            
            if let error = error as NSError? {
                //print(error)
                switch requestType {
                case .postError, .postCombinedErrors:
                    return
                case .postBin:
                    completion!(nil, error)
                    return
                case .postClientBin:
                    completion!(nil, error)
                    return
                }
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    completion!(nil,NSError(domain: "http status \(response.statusCode)", code: 666, userInfo: nil))
                    return
                }
            }
            completion!(nil, nil)
        }
        task?.resume()
    }
    
    
    
    
    
    
}

