//
//  SerializationHelperTests.swift
//  Juice
//
//  Created by Narek M on 26/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

import Foundation
import XCTest
@testable import Juice

class SerializationHelperTests: XCTestCase {
    func testHelpers() {
        do {
            let dict = "{\"double\":1.00, \"int\":1, \"bool\":true, \"string\": \"true\", \"array\":[1 ,2 ,3], \"nothing\":null}"
            let obj = try toLooselyTypedJSON(dict)
            let json = try toStrictlyTypedJSON(obj)
            guard let jsonDict = json as? JSONDictionary else {XCTFail("Not JSONDictionary?"); return}
            let double: Double = try jsonDict.decode("double")
            let int: Int = try jsonDict.decode("int")
            let bool: Bool = try jsonDict.decode("bool")
            let string: String = try jsonDict.decode("string")
            let array: Array<Int> = try jsonDict.decode("array")
            let nothing: String? = try jsonDict.decode("nothing")
            let nullNothing: NSNull = try jsonDict.decode("nothing")
            
            XCTAssertEqual(double, 1.0)
            XCTAssertEqual(int, 1)
            XCTAssertEqual(bool, true)
            XCTAssertEqual(string, "true")
            XCTAssertTrue(array.contains(1))
            XCTAssertTrue(array.contains(2))
            XCTAssertTrue(array.contains(3))
            XCTAssertNil(nothing)
            XCTAssertNotNil(nullNothing)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
