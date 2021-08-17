//
//  NetworkService.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 15.06.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation

typealias RequestCompletionHandler = (Data?, Error?) -> Void

internal class NetworkService {
    
    static let sharedRequestManager = NetworkService()
    var rsdkRequestSession : URLSession? = nil
    
    init() {
       
        let _configuration = configureRequest()
        let _session = URLSession(configuration: _configuration)
        self.rsdkRequestSession = _session
    }
    
    func configureRequest()->URLSessionConfiguration{
        let _configuration = URLSessionConfiguration.default
        _configuration.timeoutIntervalForRequest = 60 * 30 //30 Minutes
        _configuration.timeoutIntervalForResource = 60 * 30 //30 Minutes
        return _configuration
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
    
    private func createRequest(router : Router, requestInfoManager:RSdkRequestInfoManager) -> URLRequest? {
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        if let queryItems = router.parameters{
            components.queryItems = queryItems
        }
        
        
        
        guard let url = components.url else {
            switch router{
                case .postError, .postCombinedErrors:
                    return nil
            case .postBin(let data, let requestInfo), .postClientBin(let data, let requestInfo):
                NetworkService.sharedRequestManager.request(router:.postError(error: .domainError(data.snippetId, data.token, "Not valid Domain from components: \(router.host), \(router.path), \(router.scheme), \(components.description)"), requestInfo: requestInfo) )
                    return nil
            }
            
        }
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        switch router{
            case .postClientBin(let deviceData, let requestInfo):
                let encoder = JSONEncoder()
                do {
                    urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    
                    let customArgsFormatted = customArgsToString(customArgs: requestInfoManager._customArgs)
                    
                    let parameters: [String: Any] = [
                        "v": deviceData.snippetId,
                        "l": deviceData._location,
                        "d": try encoder.encode(deviceData).base64EncodedString(),
                        "va": customArgsFormatted
                    ]
                    let body = joinMapToString(map: parameters)
                    
                    urlRequest.httpBody = body.data(using:String.Encoding.utf8, allowLossyConversion: true)
                    
                } catch let error as NSError {
                    NetworkService.sharedRequestManager.request(router:.postError(error: .encodeNativeData(deviceData.snippetId, deviceData.token, error.debugDescription), requestInfo: requestInfo))
                    return nil
                }

            
            default:
                if let payload = router.payload {
                    urlRequest.setValue(RSdkVars.RequestManagerVars.encodingType, forHTTPHeaderField: RSdkVars.RequestManagerVars.encodingHeaderType)
                    urlRequest.setValue(RSdkVars.RequestManagerVars.xdib, forHTTPHeaderField: RSdkVars.RequestManagerVars.xdibContentEncoding)
                    urlRequest.httpBody = payload
                }
        }

        return urlRequest
    }
    
    func request(router: Router, completion: RequestCompletionHandler? = nil) {
        
        switch router {
            case .postClientBin(_, let requestInfo),.postBin(_, let requestInfo), .postCombinedErrors(_, let requestInfo), .postError(_, let requestInfo):
                guard let request = createRequest(router: router, requestInfoManager: requestInfo) else {
                    completion?(nil, NSError(domain: "", code: 666, userInfo: nil))
                    return
                }
                requestWithRetry(with: request, router: router)
        }
    }
    
    private func requestWithRetry(with request: URLRequest,router:Router,
                                     retries: Int = 3,
                                     completionHandler: (
                                           (Data?, URLResponse?, Error?,
                                            _ retriesLeft: Int) -> Void)? = nil) {
           
           let task = rsdkRequestSession!.dataTask(with: request) {
                                      (data, response, error) in
                if let error = error as NSError? {
                    switch router {
                    case .postError, .postCombinedErrors:
                        return
                    default:
                        completionHandler?(data, response, error, retries)
                        return
                    }
                }
                let statusCode = (response as! HTTPURLResponse).statusCode
                   
                if (200...299).contains(statusCode) {
                    completionHandler?(data,response,nil,0)
                } else if retries > 0 {
                    self.requestWithRetry(with: request,router:router,
                                     retries: retries - 1,
                                     completionHandler: completionHandler)
                } else {
                    completionHandler?(data, response, error, retries)
                }
           }
           task.resume()
       }
}
