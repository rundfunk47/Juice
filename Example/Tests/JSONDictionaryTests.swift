//
//  JSONDictionaryTests.swift
//  JuiceTests
//
//  Created by Narek M on 19/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

import XCTest
@testable import Juice

class JSONDictionaryTests: XCTestCase {
    func testSubscript() {
        let dictionary = JSONDictionary(["book": JSONDictionary(["name": "Pippi in the South Seas", "author": JSONDictionary(["name":"Astrid Lindgren", "language": "Swedish"])])])
        XCTAssertEqual(dictionary[["book"]]?.jsonString, "{\"author\": {\"language\": \"Swedish\", \"name\": \"Astrid Lindgren\"}, \"name\": \"Pippi in the South Seas\"}")
        XCTAssertEqual(dictionary[["book", "author"]]?.jsonString, "{\"language\": \"Swedish\", \"name\": \"Astrid Lindgren\"}")
        XCTAssertEqual(dictionary[["book", "author", "name"]]?.jsonString, "\"Astrid Lindgren\"")
        XCTAssertEqual(dictionary[["book", "author", "language"]]?.jsonString, "\"Swedish\"")
    }
    
    func testFailingSubscript() {
        let dictionary = JSONDictionary(["book": JSONDictionary(["name": "Pippi in the South Seas", "author": JSONDictionary(["name":"Astrid Lindgren", "language": "Swedish"])])])
        let json = dictionary[["book", "author", "blood_type"]]
        XCTAssertNil(json)
    }
}

class JSONDictionaryEncodingTypeTests: XCTestCase {
    enum Title: String, Encodable {
        case mr = "Mr."
        case mrs = "Mrs."
        case ms = "Ms."
        case miss = "Miss"
    }
    
    func testEncodePaths() {
        var dictionary = JSONDictionary()
        try! dictionary.encode(["name", "title"], value: Title.mr)
        XCTAssertEqual(dictionary.jsonString, "{\"name\": {\"title\": \"Mr.\"}}")
        try! dictionary.encode(["name", "fullName", "firstName"], value: "John")
        XCTAssertEqual(dictionary.jsonString, "{\"name\": {\"fullName\": {\"firstName\": \"John\"}, \"title\": \"Mr.\"}}")
        try! dictionary.encode(["name", "fullName", "lastName"], value: "Doe")
        XCTAssertEqual(dictionary.jsonString, "{\"name\": {\"fullName\": {\"firstName\": \"John\", \"lastName\": \"Doe\"}, \"title\": \"Mr.\"}}")
    }
    
    func testEncodeNil() {
        var dictionary = JSONDictionary()
        let value : Int? = nil
        try! dictionary.encode("number", value: value)
        XCTAssertEqual(dictionary.jsonString, "{}")
    }
    
    func testEncodeArray() {
        var dictionary = JSONDictionary()
        try! dictionary.encode("numbers", value: [1, 2, 3])
        XCTAssertEqual(dictionary.jsonString, "{\"numbers\": [1, 2, 3]}")
    }
    
    func testEncodeOptArray() {
        var dictionary = JSONDictionary()
        let array: Array<Int>? = nil
        try! dictionary.encode("numbers", value: array)
        XCTAssertEqual(dictionary.jsonString, "{}")
    }
    
    func testEncodeArrayWithOptionalInside() {
        var dictionary = JSONDictionary()
        try! dictionary.encode("numbers", value: [1, 2, nil, 4])
        XCTAssertEqual(dictionary.jsonString, "{\"numbers\": [1, 2, 4]}")
    }
    
    func testEncodeDictionary() {
        var dictionary = JSONDictionary()
        try! dictionary.encode("name", value: ["firstName": "John", "middleName": "X.", "lastName": "Doe"])
        XCTAssertEqual(dictionary.jsonString, "{\"name\": {\"firstName\": \"John\", \"lastName\": \"Doe\", \"middleName\": \"X.\"}}")
    }
    
    func testEncodeOptDictionary() {
        var dictionary = JSONDictionary()
        let insideDictionary: Dictionary<String, String>? = nil
        try! dictionary.encode("name", value: insideDictionary)
        XCTAssertEqual(dictionary.jsonString, "{}")
    }
    
    func testEncodeDictionaryWithOptionalInside() {
        var dictionary = JSONDictionary()
        let insideDictionary: Dictionary<String, String?>? = ["firstName": "John", "middleName": nil, "lastName": "Doe"]
        try! dictionary.encode(["name"], value: insideDictionary)
        XCTAssertEqual(dictionary.jsonString, "{\"name\": {\"firstName\": \"John\", \"lastName\": \"Doe\"}}")
    }
}

class JSONDictionaryDecodingTypeTests: XCTestCase {
    func testType() {
        do {
            let astrid = JSONDictionary(["name": "Astrid Lindgren", "language": "Swedish"])
            let decoded = try astrid.decode("name") as String
            XCTAssertEqual(decoded.jsonString, "\"Astrid Lindgren\"")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFailingType() {
        do {
            let astrid = JSONDictionary(["name":0, "language": "Swedish"])
            _ = try astrid.decode("name") as String
            XCTFail("Should have failed.")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["name"])
            let keypathError = "Expected \"String\" got \"Int\" with value 0."
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"name\"]: " + keypathError)
            guard let mismatchError = decodingError.underlyingError as? MismatchError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(mismatchError.localizedDescription, keypathError)
        }
    }
    
    func testOptionalType() {
        do {
            let astrid = JSONDictionary(["name": "Astrid Lindgren", "language": "Swedish"])
            let decoded = try astrid.decode("genre") as String?
            XCTAssertNil(decoded)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testNoKeyType() {
        do {
            let astrid = JSONDictionary(["name": "Astrid Lindgren", "language": "Swedish"])
            _ = try astrid.decode("genre") as String
            XCTFail("Should have failed.")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["genre"])
            let keypathError = "Key not found."
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"genre\"]: " + keypathError)
            guard let keyNotFoundError = decodingError.underlyingError as? KeyNotFoundError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(keyNotFoundError.localizedDescription, keypathError)
        }
    }
}

class JSONDictionaryDecodingDictionaryTypeTests: XCTestCase {
    func testType() {
        do {
            let airports = JSONDictionary(["airports": JSONDictionary(["YYZ": "Toronto Pearson", "DUB": "Dublin"])])
            let decoded = try airports.decode("airports") as Dictionary<String, String>
            XCTAssertEqual(decoded["YYZ"], "Toronto Pearson")
            XCTAssertEqual(decoded["DUB"], "Dublin")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFailingType() {
        do {
            let airports = JSONDictionary(["airports": JSONArray(["YYZ", "DUB"])])
            _ = try airports.decode("airports") as Dictionary<String, String>
            XCTFail("Should have failed.")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["airports"])
            let keypathError = "Expected \"JSONDictionary\" got \"JSONArray\" with value [\"YYZ\", \"DUB\"]."
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"airports\"]: " + keypathError)
            guard let mismatchError = decodingError.underlyingError as? MismatchError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(mismatchError.localizedDescription, keypathError)
        }
    }
    
    func testOptionalType() {
        do {
            let airports = JSONDictionary(["airports": JSONDictionary(["YYZ": "Toronto Pearson", "DUB": "Dublin"])])
            let decoded = try airports.decode("characters") as Dictionary<String, String>?
            XCTAssertNil(decoded)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testNoKeyType() {
        do {
            let airports = JSONDictionary(["airports": JSONDictionary(["YYZ": "Toronto Pearson", "DUB": "Dublin"])])
            _ = try airports.decode("characters") as Dictionary<String, String>
            XCTFail("Should have failed.")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["characters"])
            let keypathError = "Key not found."
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"characters\"]: " + keypathError)
            guard let keyNotFoundError = decodingError.underlyingError as? KeyNotFoundError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(keyNotFoundError.localizedDescription, keypathError)
        }
    }
}

class JSONDictionaryDecodingArrayTypeTests: XCTestCase {
    func testType() {
        do {
            let astrid = JSONDictionary(["name":"Astrid Lindgren", "characters": JSONArray(["Pippi", "Emil"])])
            let decoded = try astrid.decode("characters") as Array<String>
            XCTAssertEqual(decoded[0], "Pippi")
            XCTAssertEqual(decoded[1], "Emil")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFailingType() {
        do {
            let astrid = JSONDictionary(["Name":"Astrid Lindgren", "characters": JSONArray([0, 1])])
            _ = try astrid.decode("characters") as Array<String>
            XCTFail("Should have failed.")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["characters"])
            let keypathError = "Expected \"String\" got \"Int\" with value 0."
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"characters\"]: " + keypathError)
            guard let mismatchError = decodingError.underlyingError as? MismatchError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(mismatchError.localizedDescription, keypathError)
        }
    }
    
    func testOptionalType() {
        do {
            let astrid = JSONDictionary(["name":"Astrid Lindgren", "language": "Swedish"])
            let decoded = try astrid.decode("characters") as Array<String>?
            XCTAssertNil(decoded)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testNoKeyType() {
        do {
            let astrid = JSONDictionary(["name":"Astrid Lindgren", "language": "Swedish"])
            _ = try astrid.decode("characters") as Array<String>
            XCTFail("Should have failed.")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["characters"])
            let keypathError = "Key not found."
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"characters\"]: " + keypathError)
            guard let keyNotFoundError = decodingError.underlyingError as? KeyNotFoundError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(keyNotFoundError.localizedDescription, keypathError)
        }
    }
}
