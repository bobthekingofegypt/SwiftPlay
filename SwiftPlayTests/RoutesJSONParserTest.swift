//
//  RoutesJSONParserTest.swift
//  SwiftPlay
//
//  Created by Richard Martin on 06/08/2017.
//  Copyright © 2017 Richard Martin. All rights reserved.
//

import XCTest
import SwiftDate
@testable import SwiftPlay

class RoutesJSONParserTest: XCTestCase {
    func test_successful_parse() {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "valid-routes", ofType:
            "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        
        let parser = RoutesJSONParser()
        let results = parser.parse(with: data)
        
        XCTAssertNotNil(results)
        XCTAssertEqual(4, results?.count)
        
        let route = results![0]
        XCTAssertEqual(0, route.id)
        XCTAssertEqual(30, route.totalTime)
        XCTAssertEqual(18, route.departureDate.hour)
        XCTAssertEqual(2017, route.departureDate.year)
    }
}
