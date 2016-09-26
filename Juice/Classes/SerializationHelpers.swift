//
//  SerializationHelpers.swift
//  Juice
//
//  Created by Narek M on 26/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

private extension NSNumber {
    var isBool: Bool {
        guard let encoding = String(validatingUTF8: self.objCType) else {return false}
        switch encoding {
        case "C", "c":
            return true
        default:
            return false
        }
    }
    
    var isInt: Bool {
        guard let encoding = String(validatingUTF8: self.objCType) else {return false}
        switch encoding {
        case "Q", "L", "I", "S", "q", "l", "i", "s":
            return true
        default:
            return false
        }
    }
}

class NotValidDataError : Error {}
class NotDecodableJSONError : Error {}

/// Converts a JSON-formatted string to AnyObject
/// - Parameter string: The JSON-formatted string
/// - Returns: JSON as AnyObject
/// - Throws: A `NotValidDataError` if the string couldn't be converted to NSData with NSUTF8StringEncoding
public func toLooselyTypedJSON(_ string: String) throws -> AnyObject {
    if let data = string.data(using: String.Encoding.utf8) {
        let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return object as AnyObject
    } else {
        throw NotValidDataError() as Error
    }
}

/// Converts a loosly typed AnyObject (i.e. one returned from `NSJSONSerialization`) to the a type conforming to the `JSON`-protocol
/// - Parameter object: The object
/// - Returns: A type conforming to `JSON`
/// - Throws: A `NotDecodableJSONError` if the object isn't anything that can be represented as a `JSON`
public func toStrictlyTypedJSON(_ object: AnyObject) throws ->JSON {
    if let string = object as? String {
        return string
    }
    
    if let dictionary = object as? Dictionary<String, AnyObject> {
        return JSONDictionary(try dictionary.map({try toStrictlyTypedJSON($0)}))
    }
    
    if let array = object as? Array<AnyObject> {
        return JSONArray(try array.map({try toStrictlyTypedJSON($0)}))
    }
    
    if let number = object as? NSNumber , number.isBool {
        return number as Bool
    } else if let number = object as? NSNumber , number.isInt {
        return number as Int
    } else if let double = object as? Double {
        return double as Double
    }
    
    throw NotDecodableJSONError() as Error
}
