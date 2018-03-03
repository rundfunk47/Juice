//
//  JSON.swift
//  Juice
//
//  Created by Narek M on 19/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

/// Any data type that can be represented in JSON is conforming to this protocol.
/// These are: `String`, `Int`, `Bool`, `Double`, `NSNull`, `JSONDictionary` and `JSONArray`
public protocol JSON {
    var jsonString: String {get}
    func toLooselyTypedObject()->AnyObject
}

extension String: JSON {
    public var jsonString: String {
        return "\"" + self
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "/", with: "\\/")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\u{8}", with: "\\b")
            .replacingOccurrences(of: "\u{12}", with: "\\f")
            .replacingOccurrences(of: "\r", with: "\\r")
            .replacingOccurrences(of: "\t", with: "\\t")
            + "\""
    }

    public func toLooselyTypedObject() -> AnyObject {
        return self as AnyObject
    }
}

extension Int: JSON {
    public var jsonString: String {return String(self)}
    public func toLooselyTypedObject() -> AnyObject {
        return self as AnyObject
    }
}

extension Bool: JSON {
    public var jsonString: String {return self ? "true" : "false"}
    public func toLooselyTypedObject() -> AnyObject {
        return self as AnyObject
    }
}

extension Double: JSON {
    public var jsonString: String {return String(self)}
    public func toLooselyTypedObject() -> AnyObject {
        // Prevent rounding error
        return NSDecimalNumber(string: String(self))
    }
}

extension NSNull: JSON {
    public var jsonString: String {return "null"}
    public func toLooselyTypedObject() -> AnyObject {
        return self as AnyObject
    }
}

extension JSONDictionary: JSON {
    public var jsonString: String {
        let contents = self.map { arg -> String in
            let (key, value) = arg
            return key.jsonString + ": " + value.jsonString
        }.sorted(by: <).joined(separator: ", ")
        return "{" + contents + "}"
    }
    public func toLooselyTypedObject() -> AnyObject {
        return self.map({($0.key, $0.value.toLooselyTypedObject())}) as AnyObject
    }
}

extension JSONArray: JSON {
    public var jsonString: String {
        return "[" + self.map({$0.jsonString}).joined(separator: ", ") + "]"
    }
    public func toLooselyTypedObject() -> AnyObject {
        return self.map({$0.toLooselyTypedObject()}) as AnyObject
    }
}
