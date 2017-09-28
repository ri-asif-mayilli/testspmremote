//
//  CustomInfo.swift
//  RiskSDK
//
//  Created by Daniel Scheibe on 11.09.17.
//  Copyright © 2017 Risk.Ident GmbH. All rights reserved.
//

import Foundation
import CoreTelephony
import UIKit

class CustomInfo {
    
    public var applicationState : String {
        
        switch (UIApplication.shared.applicationState) {
            
        case .active:
            return "active"
            
        case .background:
            return "background"
            
        case.inactive:
            return "inactive"
        }
    }
}


//import Foundation
//import SystemConfiguration.CaptiveNetwork
//
//public class SSID {
//    class func getSSID() -> String{
//        var currentSSID = ""
//        let interfaces = CNCopySupportedInterfaces()
//        if interfaces != nil {
//            let interfacesArray = interfaces.takeRetainedValue() as [String : AnyObject]
//            if interfacesArray.count > 0 {
//                let interfaceName = interfacesArray[0] as String
//                let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
//                if unsafeInterfaceData != nil {
//                    let interfaceData = unsafeInterfaceData.takeRetainedValue() as Dictionary!
//                    currentSSID = interfaceData[kCNNetworkInfoKeySSID] as! String
//                    let ssiddata = NSString(data:interfaceData[kCNNetworkInfoKeySSIDData]! as! NSData, encoding:NSUTF8StringEncoding) as! String
//                    // ssid data from hex
//                    print(ssiddata)
//                }
//            }
//        }
//        return currentSSID
//    }
//}

