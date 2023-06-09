/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
//
//  NetworkInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 13.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension

fileprivate enum ProxyConfigType : String {
    
    case proxyType = "kCFProxyTypeKey"
    case proxyPort = "kCFProxyPortNumberKey"
    case proxyHost = "kCFProxyHostNameKey"
}


fileprivate enum ProxyType : String {
    
    case none                   = "kCFProxyTypeNone"
    case autoConfigurationURL   = "kCFProxyTypeAutoConfigurationURL"
    case autoConfigurationJava  = "kCFProxyTypeAutoConfigurationJavaScript"
    case typeFTP                = "kCFProxyTypeFTP"
    case typeHTTP               = "kCFProxyTypeHTTP"
    case typeHTTPS              = "kCFProxyTypeHTTPS"
    case typeSocks              = "kCFProxyTypeSOCKS"
    
    internal var isProxyConnected : Bool {
        
        switch(self) {
            
        case .none:
            return false
            
        default:
            return true
        }
    }
    
    internal var isProxyType : String? {
        
        switch(self) {
            
        case .autoConfigurationURL:
            return "ProxyTypeConfigurationURL"
            
        case .autoConfigurationJava:
            return "ProyTypeConfigurationJavaScript"
            
        case .typeFTP:
            return "ProxyTypeFTP"
            
        case .typeHTTP:
            return "ProyTypeHTTP"
            
        case .typeHTTPS:
            return "ProxyTypeHTTPS"
        case .typeSocks:
            return "ProxyTypeSocks"
            
        case .none:
            return nil
        }
    }
}

internal struct RSdkNetworkInfo {
    @available(iOS 14.0, *)
    static func getSsidIOS14(completionHandler:@escaping(String?)->Void) {
        NEHotspotNetwork.fetchCurrent(){network in
            if let unwrappedNetwork = network {
                let networkSSID = unwrappedNetwork.bssid
                completionHandler(networkSSID)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    static func getSsid(completionHandler:@escaping(String?)->Void){
        if #available(iOS 14, macCatalyst 14, *){
           
            RSdkNetworkInfo.getSsidIOS14(){ssid in
                completionHandler(ssid)
                return
            }
        } else if #available(iOS 10, macCatalyst 14, *){
            if let interfaces = CNCopySupportedInterfaces() as NSArray? {
               _ =  interfaces.map{interface in
                    let interfaceString = interface as? String ?? ""
                    let cfString = interfaceString as CFString
                    if let interfaceInfo = CNCopyCurrentNetworkInfo(cfString) as NSDictionary? {
                        let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                        completionHandler(ssid)
                        return
                    }
                }
            }
            completionHandler(nil)
        }else{
            completionHandler(nil)
        }
    }

    internal static var networkInfoGetWiFiAddressV6 : String? {
        return getIp(ipType: AF_INET6)
    }
    
    internal static var networkInfoGetWiFiAddressV4 : String? {
        return getIp(ipType: AF_INET)
    }
    
    
    private static func getIp(ipType: Int32) -> String?{
        var address : String?
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        let interfaces = sequence(first: firstAddr, next: { $0.pointee.ifa_next }).filter{
            return  $0.pointee.ifa_addr.pointee.sa_family == UInt8(ipType) && String(cString:$0.pointee.ifa_name) == "en0"
        }
        if (interfaces.isEmpty) { return nil }
       
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        let interface = interfaces[0].pointee
        getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                    &hostname, socklen_t(hostname.count),
                    nil, socklen_t(0), NI_NUMERICHOST)
        address = String(cString: hostname)
        
        
        freeifaddrs(ifaddr)
        return address
    
    }
    
    
    private static var networkInfoProxyEntry : [String : Any]? = {
        
        if let myUrl = URL(string: "http://www.apple.com"), let proxySettingsUnmanaged = CFNetworkCopySystemProxySettings() {
            let proxySettings = proxySettingsUnmanaged.takeRetainedValue()
            let proxiesUnmanaged = CFNetworkCopyProxiesForURL(myUrl as CFURL, proxySettings)
                
            if let proxies = proxiesUnmanaged.takeRetainedValue() as? [[String : Any]], !proxies.isEmpty  {
                
                return proxies[0]
            }
            
        }
        return nil
    }()
    
    internal static var networkInfoproxyHost : String? {
        
        guard let entry = networkInfoProxyEntry else { return nil }
        return entry[ProxyConfigType.proxyHost.rawValue] as? String
        
    }
    
    internal static var networkInfoProxyPort : Int? {
        
        guard let entry = networkInfoProxyEntry else { return nil }
        return entry[ProxyConfigType.proxyPort.rawValue] as? Int
    }
    
    internal static var networkInfoIsProxyConnected : Bool {
        
        guard let entry = networkInfoProxyEntry,
            let configString = entry[ProxyConfigType.proxyType.rawValue] as? String,
            let type = ProxyType(rawValue: configString)
            
            else { return false }
        return type.isProxyConnected
    }
    
    internal static var networkInfoProxyType : String? {
        
        guard let entry = networkInfoProxyEntry,
            let configString = entry[ProxyConfigType.proxyType.rawValue] as? String,
            let type = ProxyType(rawValue: configString)
            
            else { return nil }
        return type.isProxyType
    }
}

