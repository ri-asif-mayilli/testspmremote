//
//  JailbreakDTO.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 20.05.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation

struct JailbreakDTO : Codable {
    
    var appId:String?
    var created:String
    var jailBroken:Bool
    let existingPaths:[String]
    let cydiaInstalled:Bool
    let sandboxBreakOut:Bool
    
    
    init(){
        self.jailBroken = RSdkJailbreak.isJailbroken
        self.existingPaths = RSdkJailbreak.jbExistingPath
        self.cydiaInstalled = RSdkJailbreak.cydiaInstalled
        self.sandboxBreakOut = RSdkJailbreak.sandboxBreak
        self.created = Date.setDate(date:Date())
        
    }
    
    init(appID : String) {
        self.appId = appID
        self.jailBroken = RSdkJailbreak.isJailbroken
        self.existingPaths = RSdkJailbreak.jbExistingPath
        self.cydiaInstalled = RSdkJailbreak.cydiaInstalled
        self.sandboxBreakOut = RSdkJailbreak.sandboxBreak
        self.created = Date.setDate(date:Date())
    }
    
    internal init(appID : String, created: Date, existingPaths: [String]) {

        self.appId = appID
        self.created = Date.setDate(date: created)
        self.existingPaths = existingPaths
        self.jailBroken = RSdkJailbreak.isJailbroken
        self.cydiaInstalled = RSdkJailbreak.cydiaInstalled
        self.sandboxBreakOut = RSdkJailbreak.sandboxBreak
    }
    
    init(appID : String,
                  existingPaths:[String],cydiaInstalled:Bool,jailBroken:Bool,sandboxBreakOut:Bool) {
        self.appId = appID
        self.jailBroken = jailBroken
        self.existingPaths = existingPaths
        self.cydiaInstalled = cydiaInstalled
        self.sandboxBreakOut = sandboxBreakOut
        self.created = Date.setDate(date:Date())
    }
    
    init(existingPaths:[String],cydiaInstalled:Bool,jailBroken:Bool,sandboxBreakOut:Bool) {
        self.jailBroken = jailBroken
        self.existingPaths = existingPaths
        self.cydiaInstalled = cydiaInstalled
        self.sandboxBreakOut = sandboxBreakOut
        self.created = Date.setDate(date:Date())
    }
}

extension JailbreakDTO: Equatable {
    public static func ==(lhs: JailbreakDTO, rhs: JailbreakDTO) -> Bool {
        return
            lhs.appId == rhs.appId &&
            lhs.jailBroken == rhs.jailBroken &&
            lhs.existingPaths == rhs.existingPaths &&
            lhs.cydiaInstalled == rhs.cydiaInstalled &&
            lhs.sandboxBreakOut == rhs.sandboxBreakOut

    }
}
