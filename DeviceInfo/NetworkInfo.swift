//
//  NetworkInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 13.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

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
    
    internal var isConnected : Bool {
    
        switch(self) {
            
        case .none:
            return false
            
        default:
            return true
        }
    }
    
    internal var isType : String? {
        
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

struct NetworkInfo {
    
    internal static var getWiFiSsid : String? {
        
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
    internal static var getWiFiAddress : String? {
        
        var address : String?
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
    
    private static var proxyEntry : [String : Any]? = {
        
        if let myUrl = URL(string: "http://www.apple.com") {
            if let proxySettingsUnmanaged = CFNetworkCopySystemProxySettings() {
                let proxySettings = proxySettingsUnmanaged.takeRetainedValue()
                let proxiesUnmanaged = CFNetworkCopyProxiesForURL(myUrl as CFURL, proxySettings)
                
                if let proxies = proxiesUnmanaged.takeRetainedValue() as? [[String : Any]], proxies.count > 0 {

                    return proxies[0]
                }
            }
        }
        return nil
    }()
    
    
    internal static var proxyHost : String? {
        
        guard let entry = proxyEntry else { return nil }
        return entry[ProxyConfigType.proxyHost.rawValue] as? String
        
    }
    
    internal static var proxyPort : String? {

        guard let entry = proxyEntry else { return nil }
        return entry[ProxyConfigType.proxyPort.rawValue] as? String
    }
    
    internal static var isProxyConnected : Bool {
        
        guard let entry = proxyEntry,
            let configString = entry[ProxyConfigType.proxyType.rawValue] as? String,
            let type = ProxyType(rawValue: configString)
            
            else { return false }
        return type.isConnected
    }
    
    internal static var proxyType : String? {
        
        guard let entry = proxyEntry,
            let configString = entry[ProxyConfigType.proxyType.rawValue] as? String,
            let type = ProxyType(rawValue: configString)
        
        else { return nil }
        return type.isType
    }
}
