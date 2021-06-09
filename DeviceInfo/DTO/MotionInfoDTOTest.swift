//
//  MotionInfoDTOTest.swift
//  RiskSDKTests
//
//  Created by Asif Mayilli on 08.06.21.
//  Copyright © 2021 Risk.Ident GmbH. All rights reserved.
//

import XCTest
@testable import ClientSecurityKit
class MotionInfoDTOTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMotionInfoDTO() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let data = MotionInfoDTO()
        let sampleData = MotionInfoDTO(accelerometerAvailable:false, deviceMotionAvailable:false, magnetometerAvailable:false, gyroAvailable:false)
        

        XCTAssertEqual(data, sampleData)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
