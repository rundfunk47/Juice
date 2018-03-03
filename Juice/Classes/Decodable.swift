//
//  Decodable.swift
//  Juice
//
//  Created by Narek M on 19/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

/// Anything conforming to the `Decodable` protocol can be decoded into a valid Swift-type, given some JSON.
public protocol Decodable : FactoryDecodable, InitializableFromJSON {}
/// Anything conforming to the `FactoryDecodable` protocol can be decoded into a valid Swift-type, given some JSON.
/// Use when you don't own certain classes and can't provide additional initializers, examples: NSURL or NSUUID
public protocol FactoryDecodable: CreatableFromJSON {}

public protocol CreatableFromJSON {
    /// The `JSON` which we are expected to be given to be able to initialize the object.
    associatedtype ExpectedDecodeType: JSON
    /// Implement this factory in whatever you want to be able to initialize, given an expected type.
    /// Internally, this will be called after `create(fromJsonCandidate: candidate)` if the type is of the expected type.
    /// Any errors thrown will be wrapped in a `TypeDecodingError`, also by `create(fromJsonCandidate: candidate)`
    /// - Parameter fromJson: The `JSON` that will be used to initialize.
    static func create<T>(fromJson json: ExpectedDecodeType) throws -> T
    /// Try to initialize an object, given a certain `JSON`.
    /// No need to implement this since everything conforming to `InitializableFromJSON` will automatically implement this.
    /// Throws a `TypeDecodingError` if the object couldn't be decoded, `TypeMismatch` if the type is not the expected type or a `KeyIsNullError' if the object is `null`.
    /// - Parameter fromJsonCandidate: The `JSON` that will be used as a candidate to initialize.
    static func create<T>(fromJsonCandidate candidate: JSON) throws -> T
}

extension CreatableFromJSON {
    public static func create<T>(fromJsonCandidate candidate: JSON) throws -> T {
        if let value = candidate as? ExpectedDecodeType {
            do {
                return try Self.create(fromJson: value)
            } catch {
                // Catch the error and wrap it, together with the type which was attempted to be decoded.
                throw TypeDecodingError(type: Self.self, underlyingError: error)
            }
        } else if candidate is NSNull {
            throw KeyIsNullError()
        } else {
            throw MismatchError.typeMismatch(expected: ExpectedDecodeType.self, got: candidate)
        }
    }
}

/// Anything conforming to the `InitializableFromJSON` protocol can be initialized given some JSON of a certain expected type.
public protocol InitializableFromJSON {
    associatedtype ExpectedDecodeType: JSON
    /// Implement this initializer in whatever you want to be able to initialize, given an expected type.
    /// Internally, this will be called after `init(fromJsonCandidate: candidate)` if the type is of the expected type.
    /// Any errors thrown will be wrapped in a `TypeDecodingError`, also by `init(fromJsonCandidate: candidate)`
    /// - Parameter fromJson: The `JSON` that will be used to initialize.
    init(fromJson json: ExpectedDecodeType) throws
    /// Wrapper around `create(fromJsonCandidate candidate: JSON)` in `CreatableFromJSON`
    /// - Parameter fromJsonCandidate: The `JSON` that will be used as a candidate to initialize.
    init(fromJsonCandidate candidate: JSON) throws
}

extension InitializableFromJSON {
    public static func create<T>(fromJson json: ExpectedDecodeType) throws -> T {
        return try Self.init(fromJson: json) as! T
    }
}

extension InitializableFromJSON where Self: CreatableFromJSON {
    public init(fromJsonCandidate candidate: JSON) throws {
        try self = Self.create(fromJsonCandidate: candidate)
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
extension Double: Decodable {
    // Fix for bug https://github.com/rundfunk47/Juice/issues/2
    
    public static func create<T>(fromJsonCandidate candidate: JSON) throws -> T {
        if let value = candidate as? Double {
            do {
                return try Double.create(fromJson: value)
            } catch {
                // Catch the error and wrap it, together with the type which was attempted to be decoded.
                throw TypeDecodingError(type: Double.self, underlyingError: error)
            }
        } else if let value = candidate as? Int {
            do {
                return try Double.create(fromJson: Double(value))
            } catch {
                // Catch the error and wrap it, together with the type which was attempted to be decoded.
                throw TypeDecodingError(type: Double.self, underlyingError: error)
            }
        } else if candidate is NSNull {
            throw KeyIsNullError()
        } else {
            throw MismatchError.typeMismatch(expected: ExpectedDecodeType.self, got: candidate)
        }
    }
}
extension NSNull: Decodable {}
extension JSONDictionary: Decodable {}
extension JSONArray: Decodable {}
