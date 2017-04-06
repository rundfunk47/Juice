//
//  JSONDictionaryTransformTests.swift
//  JuiceTests
//
//  Created by Narek M on 19/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

import XCTest
@testable import Juice

fileprivate struct MyError: Error, CustomNSError {
    var localizedDescription: String {
        return "MyError"
    }
    
    /// The user-info dictionary.
    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: localizedDescription]
    }
    
    /// The error code within the given domain.
    public var errorCode: Int {
        return 1
    }
    
    /// The domain of the error.
    public static var errorDomain = "MyErrorDomain"
}

class JSONDictionaryDecodingTypeTransformTests: XCTestCase {
    func testTransform() {
        do {
            let webpage = JSONDictionary(["url": "http://www.apple.com"])
            let url : URL = try webpage.decode("url", transform: { (input: String) -> URL in
                return URL(string: input)!
            })
            XCTAssertEqual(url.absoluteString, "http://www.apple.com")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFailingTransform() {
        do {
            let webpage = JSONDictionary(["url": 1984])
            _ = try webpage.decode("url", transform: { (input: String) -> URL in
                XCTFail("Shouldn't be called...")
                return URL(string: input)!
            })
            XCTFail("Shouldn't get here...")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["url"])
            let keypathError = "Expected \"String\" got \"Int\" with value 1984."
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"url\"]: " + keypathError)
            guard let mismatchError = decodingError.underlyingError as? MismatchError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(mismatchError.localizedDescription, keypathError)
        }
    }
    
    func testOptionalTransform() {
        do {
            let webpage = JSONDictionary(["apple": "http://www.apple.com"])
            let url : URL? = try webpage.decode(["url"], transform: { (input: String?) -> URL? in
                if let url = input {
                    XCTFail("Shouldn't call this")
                    return URL(string: url)
                } else {
                    return nil
                }
            })
            XCTAssertNil(url)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testOptionalInputTransform() {
        do {
            let person = JSONDictionary(["name": "Jane Doe"])
            let id : String = try person.decode("id", transform: { (input: String?) -> String in
                if let id = input {
                    return id
                } else {
                    return "Unknown ID"
                }
            })
            XCTAssertEqual(id, "Unknown ID")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testNoKeyTransform() {
        do {
            let webpage = JSONDictionary(["apple": "http://www.apple.com"])
            _ = try webpage.decode("url", transform: { (input: String) -> URL in
                XCTFail("Shouldn't be called...")
                return URL(string: input)!
            })
            XCTFail("Shouldn't get here...")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["url"])
            let keypathError = "Key not found."
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"url\"]: " + keypathError)
            guard let mismatchError = decodingError.underlyingError as? KeyNotFoundError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(mismatchError.localizedDescription, keypathError)
        }
    }
    
    func testErrorPropagationTransform() {
        do {
            let webpage = JSONDictionary(["url": "http://www.apple.com"])
            _ = try webpage.decode("url", transform: { (input: String) -> URL in
                throw MyError() // fake error
            })
            XCTFail("Shouldn't get here...")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["url"])
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"url\"]: MyError")
            XCTAssertTrue(decodingError.underlyingError is MyError)
        }
    }
    
    func testErrorPropagationOptionalTransform() {
        do {
            let webpage = JSONDictionary(["url": "http://www.apple.com"])
            _ = try webpage.decode("url", transform: { (input: String?) -> URL in
                throw MyError() // fake error
            })
            XCTFail("Shouldn't get here...")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["url"])
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"url\"]: MyError")
            XCTAssertTrue(decodingError.underlyingError is MyError)
        }
    }
}

class JSONDictionaryDecodingDictionaryTypeTransformTests: XCTestCase {
    func testTransform() {
        do {
            let company = JSONDictionary(["company": JSONDictionary(["url": "http://www.apple.com"])])
            let url : URL = try company.decode("company", transform: {(input: Dictionary<String, String>) -> URL in
                return URL(string: input["url"]!)!
            })
            XCTAssertEqual(url.absoluteString, "http://www.apple.com")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFailingTransform() {
        do {
            let company = JSONDictionary(["company": 1984])
            _ = try company.decode("company", transform: {(input: Dictionary<String, String>) -> URL in
                XCTFail("Shouldn't be called...")
                return URL(string: input["url"]!)!
            })
            XCTFail("Shouldn't get here...")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["company"])
            let keypathError = "Expected \"JSONDictionary\" got \"Int\" with value 1984."
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"company\"]: " + keypathError)
            guard let mismatchError = decodingError.underlyingError as? MismatchError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(mismatchError.localizedDescription, keypathError)
        }
    }
    
    func testOptionalTransform() {
        do {
            let company = JSONDictionary(["company": JSONDictionary(["url": "http://www.apple.com"])])
            let url : URL? = try company.decode(["characters"], transform: { (input: Dictionary<String, String>?) -> URL? in
                if input != nil {
                    XCTFail("Shouldn't call this")
                    return URL(string: input!["company"]!)!
                } else {
                    return nil
                }
            })
            XCTAssertNil(url)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testOptionalInputTransform() {
        do {
            let person = JSONDictionary(["name": "Jane Doe"])
            let owns : String = try person.decode(["owns"], transform: { (input: Dictionary<String, String>?) -> String in
                if let _ = input {
                    return "Owns stuff"
                } else {
                    return "Owns nothing"
                }
            })
            XCTAssertEqual(owns, "Owns nothing")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testNoKeyTransform() {
        do {
            let webpage = JSONDictionary(["apple": "http://www.apple.com"])
            _ = try webpage.decode("site", transform: { (input: Dictionary<String, String>) -> URL in
                XCTFail("Shouldn't be called...")
                return URL(string: input["address"]!)!
            })
            XCTFail("Shouldn't get here...")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["site"])
            let keypathError = "Key not found."
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"site\"]: " + keypathError)
            guard let mismatchError = decodingError.underlyingError as? KeyNotFoundError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(mismatchError.localizedDescription, keypathError)
        }
    }
    
    func testErrorPropagationTransform() {
        do {
            let company = JSONDictionary(["company": JSONDictionary(["url": "http://www.apple.com"])])
            _ = try company.decode("company", transform: { (input: Dictionary<String, String>) -> URL in
                throw MyError() // fake error
            })
            XCTFail("Shouldn't get here...")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["company"])
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"company\"]: MyError")
            XCTAssertTrue(decodingError.underlyingError is MyError)
        }
    }
    
    func testErrorPropagationOptionalTransform() {
        do {
            let company = JSONDictionary(["company": JSONDictionary(["url": "http://www.apple.com"])])
            _ = try company.decode("company", transform: { (input: Dictionary<String, String>?) -> URL in
                throw MyError() // fake error
            })
            XCTFail("Shouldn't get here...")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["company"])
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"company\"]: MyError")
            XCTAssertTrue(decodingError.underlyingError is MyError)
        }
    }
}

class JSONDictionaryDecodingArrayTypeTransformTests: XCTestCase {
    func testTransform() {
        do {
            let company = JSONDictionary(["numbers": JSONArray([1, 2, 3, 4, 5])])
            let added : Int = try company.decode("numbers", transform: { (input: Array<Int>) -> Int in
                return input.reduce(0, {$0 + $1})
            })
            XCTAssertEqual(added, 15)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFailingTransform() {
        do {
            let numbers = JSONDictionary(["numbers": JSONArray([1, 2, 3, 4, 5])])
            _ = try numbers.decode("numbers", transform: { (input: Array<String>) -> String in
                XCTFail("Shouldn't be called...")
                return input.reduce("", {$0 + $1})
            })
            XCTFail("Shouldn't get here...")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["numbers"])
            let keypathError = "Expected \"String\" got \"Int\" with value 1."
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"numbers\"]: " + keypathError)
            guard let mismatchError = decodingError.underlyingError as? MismatchError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(mismatchError.localizedDescription, keypathError)
        }
    }
    
    func testOptionalTransform() {
        do {
            let numbers = JSONDictionary(["numbers": JSONArray([1, 2, 3, 4, 5])])
            let url : String? = try numbers.decode(["letters"], transform: { (input: Array<String>?) -> String? in
                if input != nil {
                    XCTFail("Shouldn't call this")
                    return input!.reduce("", {$0! + $1})
                } else {
                    return nil
                }
            })
            XCTAssertNil(url)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testOptionalInputTransform() {
        do {
            let numbers = JSONDictionary(["numbers": JSONArray([1, 2, 3, 4, 5])])
            let owns : String = try numbers.decode("letters", transform: { (input: Array<String>?) -> String in
                if let _ = input {
                    return "Letters"
                } else {
                    return "No letters"
                }
            })
            XCTAssertEqual(owns, "No letters")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testNoKeyTransform() {
        do {
            let numbers = JSONDictionary(["numbers": JSONArray([1, 2, 3, 4, 5])])
            _ = try numbers.decode("added", transform: { (input: Int) -> String in
                XCTFail("Shouldn't be called...")
                return String(input)
            })
            XCTFail("Shouldn't get here...")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["added"])
            let keypathError = "Key not found."
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"added\"]: " + keypathError)
            guard let mismatchError = decodingError.underlyingError as? KeyNotFoundError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(mismatchError.localizedDescription, keypathError)
        }
    }
    
    func testErrorPropagationTransform() {
        do {
            let numbers = JSONDictionary(["numbers": JSONArray([1, 2, 3, 4, 5])])
            _ = try numbers.decode("numbers", transform: { (input: Array<Int>) -> Int in
                throw MyError() // fake error
            })
            XCTFail("Shouldn't get here...")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["numbers"])
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"numbers\"]: MyError")
            XCTAssertTrue(decodingError.underlyingError is MyError)
        }
    }
    
    func testErrorPropagationOptionalTransform() {
        do {
            let numbers = JSONDictionary(["numbers": JSONArray([1, 2, 3, 4, 5])])
            _ = try numbers.decode("numbers", transform: { (input: Array<Int>?) -> Int in
                throw MyError() // fake error
            })
            XCTFail("Shouldn't get here...")
        } catch {
            guard let decodingError = error as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(decodingError.keyPath, ["numbers"])
            XCTAssertEqual(decodingError.localizedDescription, "Error at key path [\"numbers\"]: MyError")
            XCTAssertTrue(decodingError.underlyingError is MyError)
        }
    }
}
