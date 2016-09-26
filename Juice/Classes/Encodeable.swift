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

extension String: Encodable {}
extension Int: Encodable {}
extension Bool: Encodable {}
extension Double: Encodable {}
