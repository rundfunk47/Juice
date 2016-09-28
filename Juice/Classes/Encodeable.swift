//
//  Encodeable.swift
//  Juice
//
//  Created by Narek M on 25/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

public protocol Encodable {
    /// The `JSON` which we get after encoding.
    associatedtype EncodeType: JSON
    func encode() throws -> EncodeType
}

extension RawRepresentable where Self: Encodable, Self.RawValue: JSON {
    // Makes it so that we can encode all Enums that have a `RawValue` that conforms to `JSON`
    public func encode() throws -> Self.RawValue {
        return self.rawValue
    }
}

extension JSON where Self: Encodable {
    // Makes sure we can encode everything which is already conforming to the protocol `JSON`
    public func encode() throws -> Self {
        return self
    }
}

// Not conforming to protocol due to limitations in Swift, but still implements encode:
extension Array where Element: Encodable {
    public func encode() throws -> JSONArray {
        return JSONArray(try self.map{try $0.encode()})
    }
}

// Not conforming to protocol due to limitations in Swift, but still implements encode:
extension Dictionary where Key: CustomStringConvertible, Value: Encodable {
    public func encode() throws -> JSONDictionary {
        return JSONDictionary(try self.map{return (JSONDictionary.Key(describing: $0), try $1.encode() as JSONDictionary.Value)})
    }
}

extension String: Encodable {}
extension Int: Encodable {}
extension Bool: Encodable {}
extension Double: Encodable {}
