//
//  JSONDictionary+Encode+Transform.swift
//  Juice
//
//  Created by Narek M on 31/08/16.
//  Copyright © 2016 Narek. All rights reserved.
//

import Foundation

public extension JSONDictionary {
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Parameter value: What to encode.
    /// - Parameter transform: The transform to apply
    mutating func encode<T, U: Encodable>(_ key: String, value: T, transform: (_ input: T) throws -> U?) throws {
        let transformedValue = try transform(value)
        try self.encode(key, value: transformedValue)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Parameter value: What to encode.
    /// - Parameter transform: The transform to apply
    mutating func encode<T, U: Encodable>(_ key: String, value: T, transform: (_ input: T) throws -> Array<U>?) throws {
        let transformedValue = try transform(value)
        try self.encode(key, value: transformedValue)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Parameter value: What to encode.
    /// - Parameter transform: The transform to apply
    mutating func encode<T, U: Encodable>(_ key: String, value: T, transform: (_ input: T) throws -> Dictionary<String, U>?) throws {
        let transformedValue = try transform(value)
        try self.encode(key, value: transformedValue)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Parameter value: What to encode.
    /// - Parameter transform: The transform to apply
    mutating func encode<T: Encodable>(_ key: String, value: T, transform: (_ input: T) throws -> JSONDictionary) throws {
        let transformedValue = try transform(value)
        try self.encode(key, value: transformedValue)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Parameter value: What to encode.
    /// - Parameter transform: The transform to apply
    mutating func encode<T, U: Encodable>(_ key: String, value: T, transform: (_ input: T) throws -> Array<U?>) throws {
        let transformedValue = try transform(value)
        try self.encode(key, value: transformedValue)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Parameter value: What to encode.
    /// - Parameter transform: The transform to apply
    mutating func encode<T, U: Encodable>(_ key: String, value: T, transform: (_ input: T) throws -> Dictionary<String, U?>) throws {
        let transformedValue = try transform(value)
        try self.encode(key, value: transformedValue)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter keyPath: Array of strings.
    /// - Parameter value: What to encode.
    /// - Parameter transform: The transform to apply
    mutating func encode<T, U: Encodable>(_ keyPath: [String], value: T, transform: (_ input: T) throws -> U?) throws {
        let transformedValue = try transform(value)
        try self.encode(keyPath, value: transformedValue)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter keyPath: Array of strings.
    /// - Parameter value: What to encode.
    /// - Parameter transform: The transform to apply
    mutating func encode<T, U: Encodable>(_ keyPath: [String], value: T, transform: (_ input: T) throws -> Array<U>?) throws {
        let transformedValue = try transform(value)
        try self.encode(keyPath, value: transformedValue)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter keyPath: Array of strings.
    /// - Parameter value: What to encode.
    /// - Parameter transform: The transform to apply
    mutating func encode<T, U: Encodable>(_ keyPath: [String], value: T, transform: (_ input: T) throws -> Dictionary<String, U>?) throws {
        let transformedValue = try transform(value)
        try self.encode(keyPath, value: transformedValue)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter keyPath: Array of strings.
    /// - Parameter value: What to encode.
    /// - Parameter transform: The transform to apply
    mutating func encode<T, U: Encodable>(_ keyPath: [String], value: T, transform: (_ input: T) throws -> Array<U?>) throws {
        let transformedValue = try transform(value)
        try self.encode(keyPath, value: transformedValue)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter keyPath: Array of strings.
    /// - Parameter value: What to encode.
    /// - Parameter transform: The transform to apply
    mutating func encode<T, U: Encodable>(_ keyPath: [String], value: T, transform: (_ input: T) throws -> Dictionary<String, U?>) throws {
        let transformedValue = try transform(value)
        try self.encode(keyPath, value: transformedValue)
    }
}
