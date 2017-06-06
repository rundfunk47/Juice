//
//  DecodingTests.swift
//  JuiceTests
//
//  Created by Narek M on 19/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

import Foundation
import XCTest
@testable import Juice

/// A collection of tests to fully decode a custom object.
class DecodingTests: XCTestCase {
    enum Department: String, Juice.Decodable {
        case sales
        case personnel
        case engineering
    }
    
    struct Employee: Juice.Decodable {
        let age: Int
        let departments: Array<Department>
        let hourlyWage: Double
        let name: String
        let working: Bool
        
        init(fromJson json: JSONDictionary) throws {
            age = try json.decode("Age")
            departments = try json.decode("Departments")
            hourlyWage = try json.decode("HourlyWage")
            name = try json.decode("Name")
            working = try json.decode("Working")
        }
    }
    
    func testPrinting() {
        let john = JSONDictionary(["Age": 35, "Departments": JSONArray(["sales", "engineering"]), "Name": "John Doe", "HourlyWage": 8.31, "Working": true])
        let jane = JSONDictionary(["Age": 32, "Departments": JSONArray(["engineering"]), "Name": "Jane Doe", "HourlyWage": 9.20, "Working": false])
        XCTAssertEqual(john.jsonString,"{\"Age\": 35, \"Departments\": [\"sales\", \"engineering\"], \"HourlyWage\": 8.31, \"Name\": \"John Doe\", \"Working\": true}")
        XCTAssertEqual(jane.jsonString, "{\"Age\": 32, \"Departments\": [\"engineering\"], \"HourlyWage\": 9.2, \"Name\": \"Jane Doe\", \"Working\": false}")
    }
    
    func testObjectDecoding() {
        do {
            let dictionary = JSONDictionary(["Age": 35, "Departments": JSONArray(["sales", "engineering"]), "Name": "John Doe", "HourlyWage": 8.31, "Working": true])
            let employee = try Employee(fromJsonCandidate: dictionary)
            XCTAssertEqual(employee.age, 35)
            XCTAssertEqual(employee.departments, [.sales, .engineering])
            XCTAssertEqual(employee.name, "John Doe")
            XCTAssertEqual(employee.hourlyWage, 8.31)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testObjectFailureDecodingUnmappedEnum() {
        do {
            let dictionary = JSONDictionary(["Age": 35, "Departments": JSONArray(["sales", "engineering", "unknown"]), "Name": "John Doe", "HourlyWage": 8.31, "Working": true])
            _ = try Employee(fromJsonCandidate: dictionary)
            XCTFail("Shouldn't succeed.")
        } catch {
            guard let employeeDecodingError = error as? TypeDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(String(describing: Mirror(reflecting: employeeDecodingError.type).subjectType), "Employee.Type")
            guard let dictionaryDecodingError = employeeDecodingError.underlyingError as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(dictionaryDecodingError.keyPath, ["Departments"])
            guard let departmentDecodingError = dictionaryDecodingError.underlyingError as? TypeDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(String(describing: Mirror(reflecting: departmentDecodingError.type).subjectType), "Department.Type")
            guard let enumDecodingError = departmentDecodingError.underlyingError as? MismatchError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(enumDecodingError.localizedDescription, "Enum couldn\'t be mapped with gotten value \"unknown\".")
            XCTAssertEqual(employeeDecodingError.localizedDescription, "Failure when attempting to decode type Employee: Error at key path [\"Departments\"]: Failure when attempting to decode type Department: Enum couldn\'t be mapped with gotten value \"unknown\".")
            
            // Test CustomNSError:
            let nserror = (employeeDecodingError as NSError)
            XCTAssertEqual(nserror.domain, "JuiceErrorDomain")
            XCTAssertEqual(nserror.code, JuiceTypeDecodingError)
            XCTAssertEqual(nserror.userInfo[NSLocalizedDescriptionKey] as? String, "Failure when attempting to decode type Employee: Error at key path [\"Departments\"]: Failure when attempting to decode type Department: Enum couldn\'t be mapped with gotten value \"unknown\".")
            let underlyingnserror1 = nserror.userInfo[NSUnderlyingErrorKey] as? NSError
            XCTAssertEqual(underlyingnserror1?.domain, "JuiceErrorDomain")
            XCTAssertEqual(underlyingnserror1?.code, JuiceDictionaryDecodingError)
            XCTAssertEqual(underlyingnserror1?.userInfo[NSLocalizedDescriptionKey] as? String, "Error at key path [\"Departments\"]: Failure when attempting to decode type Department: Enum couldn\'t be mapped with gotten value \"unknown\".")
            let underlyingnserror2 = underlyingnserror1?.userInfo[NSUnderlyingErrorKey] as? NSError
            XCTAssertEqual(underlyingnserror2?.domain, "JuiceErrorDomain")
            XCTAssertEqual(underlyingnserror2?.code, JuiceTypeDecodingError)
            XCTAssertEqual(underlyingnserror2?.userInfo[NSLocalizedDescriptionKey] as? String, "Failure when attempting to decode type Department: Enum couldn\'t be mapped with gotten value \"unknown\".")
            let underlyingnserror3 = underlyingnserror2?.userInfo[NSUnderlyingErrorKey] as? NSError
            XCTAssertEqual(underlyingnserror3?.domain, "JuiceErrorDomain")
            XCTAssertEqual(underlyingnserror3?.code, JuiceUnmappedEnum)
            XCTAssertEqual(underlyingnserror3?.userInfo[NSLocalizedDescriptionKey] as? String, "Enum couldn't be mapped with gotten value \"unknown\".")
        }
    }
    
    func testObjectFailureDecodingWrongTypeEnum() {
        do {
            let dictionary = JSONDictionary(["Age": 35, "Departments": JSONArray(["sales", "engineering", 4]), "Name": "John Doe", "HourlyWage": 8.31, "Working": true])
            _ = try Employee(fromJsonCandidate: dictionary)
            XCTFail("Shouldn't succeed.")
        } catch {
            guard let employeeDecodingError = error as? TypeDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(String(describing: Mirror(reflecting: employeeDecodingError.type).subjectType), "Employee.Type")
            guard let dictionaryDecodingError = employeeDecodingError.underlyingError as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(dictionaryDecodingError.keyPath, ["Departments"])
            guard let mismatchError = dictionaryDecodingError.underlyingError as? MismatchError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(mismatchError.localizedDescription, "Expected \"String\" got \"Int\" with value 4.")
            XCTAssertEqual(employeeDecodingError.localizedDescription, "Failure when attempting to decode type Employee: Error at key path [\"Departments\"]: Expected \"String\" got \"Int\" with value 4.")
            
            // Test CustomNSError:
            let nserror = (employeeDecodingError as NSError)
            XCTAssertEqual(nserror.domain, "JuiceErrorDomain")
            XCTAssertEqual(nserror.code, JuiceTypeDecodingError)
            XCTAssertEqual(nserror.userInfo[NSLocalizedDescriptionKey] as? String, "Failure when attempting to decode type Employee: Error at key path [\"Departments\"]: Expected \"String\" got \"Int\" with value 4.")
            let underlyingnserror1 = nserror.userInfo[NSUnderlyingErrorKey] as? NSError
            XCTAssertEqual(underlyingnserror1?.domain, "JuiceErrorDomain")
            XCTAssertEqual(underlyingnserror1?.code, JuiceDictionaryDecodingError)
            XCTAssertEqual(underlyingnserror1?.userInfo[NSLocalizedDescriptionKey] as? String, "Error at key path [\"Departments\"]: Expected \"String\" got \"Int\" with value 4.")
            let underlyingnserror2 = underlyingnserror1?.userInfo[NSUnderlyingErrorKey] as? NSError
            XCTAssertEqual(underlyingnserror2?.domain, "JuiceErrorDomain")
            XCTAssertEqual(underlyingnserror2?.code, JuiceTypeMismatch)
            XCTAssertEqual(underlyingnserror2?.userInfo[NSLocalizedDescriptionKey] as? String, "Expected \"String\" got \"Int\" with value 4.")
        }
    }
    
    func testObjectFailureDecodingKeyNotFound() {
        do {
            let dictionary = JSONDictionary(["Departments": JSONArray(["sales", "engineering"]), "Name": "John Doe", "HourlyWage": 8.31, "Working": true])
            _ = try Employee(fromJsonCandidate: dictionary)
            XCTFail("Shouldn't succeed.")
        } catch {
            guard let employeeDecodingError = error as? TypeDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(String(describing: Mirror(reflecting: employeeDecodingError.type).subjectType), "Employee.Type")
            guard let dictionaryDecodingError = employeeDecodingError.underlyingError as? DictionaryDecodingError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(dictionaryDecodingError.keyPath, ["Age"])
            guard let mismatchError = dictionaryDecodingError.underlyingError as? KeyNotFoundError else {XCTFail("Wrong kind of error..."); return}
            XCTAssertEqual(mismatchError.localizedDescription, "Key not found.")
            XCTAssertEqual(employeeDecodingError.localizedDescription, "Failure when attempting to decode type Employee: Error at key path [\"Age\"]: Key not found.")
            
            // Test CustomNSError:
            let nserror = (employeeDecodingError as NSError)
            XCTAssertEqual(nserror.domain, "JuiceErrorDomain")
            XCTAssertEqual(nserror.code, JuiceTypeDecodingError)
            XCTAssertEqual(nserror.userInfo[NSLocalizedDescriptionKey] as? String, "Failure when attempting to decode type Employee: Error at key path [\"Age\"]: Key not found.")
            let underlyingnserror1 = nserror.userInfo[NSUnderlyingErrorKey] as? NSError
            XCTAssertEqual(underlyingnserror1?.domain, "JuiceErrorDomain")
            XCTAssertEqual(underlyingnserror1?.code, JuiceDictionaryDecodingError)
            XCTAssertEqual(underlyingnserror1?.userInfo[NSLocalizedDescriptionKey] as? String, "Error at key path [\"Age\"]: Key not found.")
            let underlyingnserror2 = underlyingnserror1?.userInfo[NSUnderlyingErrorKey] as? NSError
            XCTAssertEqual(underlyingnserror2?.domain, "JuiceErrorDomain")
            XCTAssertEqual(underlyingnserror2?.code, JuiceKeyNotFound)
            XCTAssertEqual(underlyingnserror2?.userInfo[NSLocalizedDescriptionKey] as? String, "Key not found.")
        }
    }
}
