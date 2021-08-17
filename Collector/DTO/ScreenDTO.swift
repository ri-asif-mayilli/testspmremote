//
//  ScreenDTO.swift
//  RiskSDK
//
//  Created by Asif Mayilli on 03.06.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import Foundation

struct ScreenDTO : Codable {
    
    let idiom:String
    let interfaceLayout:String
    let bounds:ScreenBoundDTO
    let size:ScreenSizeDTO
    
    
    init() {
        self.idiom = RSdkDisplay.rsdkDisplayUserInterfaceIdiom
        self.interfaceLayout = RSdkDisplay.rsdkUserInterfaceLayout
        self.bounds = ScreenBoundDTO()
        self.size = ScreenSizeDTO()
    }
    
    init(idiom:String,interfaceLayout:String,bounds:ScreenBoundDTO,size:ScreenSizeDTO) {
        self.idiom = idiom
        self.interfaceLayout = interfaceLayout
        self.bounds = bounds
        self.size = size
    }
}

extension ScreenDTO: Equatable {
    public static func ==(lhs: ScreenDTO, rhs: ScreenDTO) -> Bool {
        return
            lhs.idiom == rhs.idiom &&
            lhs.interfaceLayout == rhs.interfaceLayout &&
            lhs.bounds == rhs.bounds &&
            lhs.size == rhs.size
    }
}



struct ScreenBoundDTO : Codable {
    
    let minX:Float
    let maxX:Float
    let minY:Float
    let maxY:Float
    let height:Float
    let width:Float
    
    init(){
        self.minX = RSdkDisplay.rsdkScreenBoundMinX
        self.maxX = RSdkDisplay.rsdkScreenBoundMaxX
        self.minY = RSdkDisplay.rsdkScreenBoundMinY
        self.maxY = RSdkDisplay.rsdkScreenBoundMaxX
        self.height = RSdkDisplay.rsdkScreenBoundHeight
        self.width = RSdkDisplay.rsdkScreenBoundWidth
    }
    
    init(minX:Float, maxX:Float, minY:Float, maxY:Float,height:Float, width:Float){
        self.minX = minX
        self.maxX = maxX
        self.minY = minY
        self.maxY = maxY
        self.height = height
        self.width = width
    }
}

extension ScreenBoundDTO: Equatable {
    public static func ==(lhs: ScreenBoundDTO, rhs: ScreenBoundDTO) -> Bool {
        return
            lhs.minX == rhs.minX &&
            lhs.maxX == rhs.maxX &&
            lhs.minY == rhs.minY &&
            lhs.maxY == rhs.maxY &&
            lhs.height == rhs.height &&
            lhs.width == rhs.width
        
    }
}

struct ScreenSizeDTO : Codable {
    
    let height:Float
    let width:Float
    
    init(){
        self.height = RSdkDisplay.rsdkScreenSizeHeight
        self.width  = RSdkDisplay.rsdkScreenBoundWidth
    }
    
    init(height:Float, width:Float){
        self.height = height
        self.width  = width
    }
}

extension ScreenSizeDTO: Equatable {
    public static func ==(lhs: ScreenSizeDTO, rhs: ScreenSizeDTO) -> Bool {
        return
            lhs.height == rhs.height &&
            lhs.width == rhs.width
        
    }
}
