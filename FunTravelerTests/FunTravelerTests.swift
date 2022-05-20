//
//  FunTravelerTests.swift
//  FunTravelerTests
//
//  Created by 林翊婷 on 2022/5/19.
//

import XCTest
@testable import FunTraveler

class FunTravelerTests: XCTestCase {
    var sut: RearrangeTimeManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RearrangeTimeManager()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testOnlyOneSchedule() throws {
        let mockSchedule: [Schedule] = [
            Schedule(name: "", day: 1, address: "", startTime: "", duration: 1.0, trafficTime: 1.0, type: "", position: Position(lat: 2.5, long: 2.5))
        ]

        let trafficTime = sut.calculateTrafficTime(1, mockSchedule)
 
        
        XCTAssertEqual(trafficTime, 0)
    }
    
    func testMultipleSchedule() throws {
        let multipleSchedule: [Schedule] = [
            Schedule(name: "", day: 1, address: "", startTime: "", duration: 1.0, trafficTime: 1.0, type: "", position: Position(lat: 25.041012, long: 121.56516)),
            Schedule(name: "", day: 1, address: "", startTime: "", duration: 1.0, trafficTime: 1.0, type: "", position: Position(lat: 25.036215, long: 121.56727))
        ]

        let trafficTime = sut.calculateTrafficTime(0, multipleSchedule)
        
        XCTAssertEqual(trafficTime, 572.4575439142843)
    }
    
    func testWrongIndex() throws {
        let oneSchedule: [Schedule] = [
            Schedule(name: "", day: 1, address: "", startTime: "", duration: 1.0, trafficTime: 1.0, type: "", position: Position(lat: 2.5, long: 2.5))
        ]

        let trafficTime = sut.calculateTrafficTime(2, oneSchedule)
 
        XCTAssertEqual(trafficTime, 0)
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
