//
//  Decodable.swift
//  Juice
//
//  Created by Narek M on 19/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

/// Anything conforming to the `Decodable` protocol can be decoded into a valid Swift-type, given some JSON.
public protocol Decodable : InitializableFromJSON {}

/// Anything conforming to the `InitializableFromJSON` protocol can be initialized given some JSON of a certain expected type.
public protocol InitializableFromJSON {
    /// The `JSON` which we are expected to be given to be able to initialize the object.
    associatedtype ExpectedDecodeType: JSON
    /// Implement this initializer in whatever you want to be able to initialize, given an expected type.
    /// Internally, this will be called after `init(fromJsonCandidate: candidate)` if the type is of the expected type.
    /// Any errors thrown will be wrapped in a `TypeDecodingError`, also by `init(fromJsonCandidate: candidate)`
    /// - Parameter fromJson: The `JSON` that will be used to initialize.
    init(fromJson json: ExpectedDecodeType) throws
    /// Try to initialize an object, given a certain `JSON`.
    /// No need to implement this since everything conforming to `InitializableFromJSON` will automatically implement this.
    /// Throws a `TypeDecodingError` if the object couldn't be decoded, or `TypeMismatch` if the type is not the expected type.
    /// - Parameter fromJsonCandidate: The `JSON` that will be used as a candidate to initialize.
    init(fromJsonCandidate candidate: JSON) throws
}

extension InitializableFromJSON {
    public init(fromJsonCandidate candidate: JSON) throws {
        if let value = candidate as? ExpectedDecodeType {
            do {
                try self.init(fromJson: value)
            } catch {
                // Catch the error and wrap it, together with the type which was attempted to be decoded.
                throw TypeDecodingError(type: Self.self, underlyingError: error)
            }
        } else {
            throw MismatchError.typeMismatch(expected: ExpectedDecodeType.self, got: candidate)
        }
    }
}

extension RawRepresentable where Self: InitializableFromJSON, Self.RawValue: JSON {
    // Makes it so that we can decode all Enums that have a `RawValue` that conforms to `JSON`
    public init(fromJson json: Self.RawValue) throws {
        if let value = Self(rawValue: json) {
            self = value
        } else {
            throw MismatchError.unmappedEnum(got: json)
        }
    }
}

extension JSON where Self: InitializableFromJSON {
    // Makes sure we can initialize everything which is already conforming to the protocol `JSON`
    public init(fromJson json: Self) {
        self = json
    }
}

extension String: Decodable {}
extension Int: Decodable {}
extension Bool: Decodable {}
extension Double: Decodable {}
extension JSONDictionary: Decodable {}
extension JSONArray: Decodable {}
