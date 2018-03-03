//
//  NumberTests.swift
//  Juice_Tests
//
//  Created by Narek M on 2018-03-04.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import Juice

private extension Double {
    var isInteger: Bool {
        return rint(self) == self
    }
}

class DoubleTests: XCTestCase {
    func testNSNumberDouble() {
        for double in stride(from: 0.0, to: 100000, by: 0.01) {
            let number = double.toLooselyTypedObject()
            let numberString = double.isInteger ? String(describing: number) + ".0" : String(describing: number)
            XCTAssertEqual(numberString, double.jsonString)
        }
    }
}
