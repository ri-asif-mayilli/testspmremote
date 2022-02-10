//
//  Router.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 15.06.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation




enum Router {
    
    case postBin(payload:RSdkDeviceDTO,requestInfo:RSdkRequestInfoManager)
    case postClientBin(payload:RSdkDeviceDTO,requestInfo:RSdkRequestInfoManager)
    case postError(error:RSdkErrorType,requestInfo:RSdkRequestInfoManager)
    case postCombinedErrors(error: RSDKCombinedErrorDTO,requestInfo:RSdkRequestInfoManager)
    
    
    var scheme: String {
        switch self {
        case .postBin, .postClientBin, .postError, .postCombinedErrors:
            
            return "https"
        }
    }
    
    var host: String {
        switch self {
            case .postBin, .postClientBin, .postError, .postCombinedErrors:
                return  RSdkVars.HOST
        }
        
    }
    
    
    var parameters: [URLQueryItem]? {
            switch self {
            case .postClientBin(let data, _):
                return [URLQueryItem(name: "t", value: data.token)]
            default:
                return nil
            }
        }

    var path: String {
        switch self {
        case .postBin(let data, _):
            return "\(RSdkVars.POST_PATH)/\(data.snippetId)\(RSdkVars.ENDPOINT_ADDITIONAL)\(data.token)"
        case .postClientBin(_,  _):
            return "/ni"
        case .postError(let error,  _):
            return "/\(RSdkVars.ERROR_PATH)/\(error._snippetId)\(RSdkVars.ENDPOINT_ADDITIONAL)\(error._requestToken)"
        case .postCombinedErrors(let error,  _):
            return "/\(RSdkVars.ERROR_PATH)/\(error.snippetId)\(RSdkVars.ENDPOINT_ADDITIONAL)\(error.token)"
        }
    }
    

    
    var payload : Data? {
        switch(self) {
        case .postBin(let payload, let requestInfo):
            return setPayload(payload: payload, requestInfoManager: requestInfo) ?? nil
        case .postClientBin(let payload, let requestInfo):
            return setPayload(payload: payload, requestInfoManager: requestInfo) ?? nil
        case .postError(let error, _):
            let encoder = JSONEncoder()
            do {
                let dto = RSdkErrorDTO(error)
                let enc = try encoder.encode(dto).base64EncodedData()
                return enc
            } catch {
                return nil
            }
        case .postCombinedErrors(let error, _):
            let encoder = JSONEncoder()
            do {
                let enc = try encoder.encode(error).base64EncodedData()
                return enc
            } catch {
                return nil
            }
        }
    }
    
    func setPayload(payload:RSdkDeviceDTO,requestInfoManager:RSdkRequestInfoManager)->Data?{
        let encoder = JSONEncoder()
        do {
            let enc = try encoder.encode(payload).base64EncodedData()
            return enc
            
        } catch let error as NSError {
            NetworkService.sharedRequestManager.request(router: .postError(error: .encodeNativeData(payload.snippetId, payload.token, error.debugDescription),requestInfo:requestInfoManager))
            return nil
        }
    }
    
    var method: String {
        switch self {
        case .postBin, .postError, .postCombinedErrors:
            return "PUT"
        case  .postClientBin:
            return "POST"
        }
    }
    
    
    
    
}
