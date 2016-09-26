//
//  JSONDictionary+Decode+Transform.swift
//  Juice
//
//  Created by Narek M on 19/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

// MARK: Main methods to decode and transform given a key path

public extension JSONDictionary {
    /// Decodes a type in the dictionary, given a key path, after which the transform will be applied.
    /// - Parameter keyPath: Array of strings.
    /// - Parameter transform: The transform to apply on the type. Errors thrown here will fail decoding and be wrapped in a `DictionaryDecodingError`.
    /// - Returns: A transformed type.
    /// - Throws: A `DictionaryDecodingError`, a `KeyNotFoundError` if key was not found, or any other error that was encountered when trying to decode.
    func decode<T: Decodable, U>(_ keyPath: [JSONDictionary.Key], transform: (_ input: T) throws -> U) throws -> U {
        let decodedJson = try self.decode(keyPath) as T
        do {
            return try transform(decodedJson)
        } catch {
            // Catch any errors and wrap them, together with the key path.
            throw DictionaryDecodingError(keyPath: keyPath, underlyingError: error)
        }
    }
    
    /// Decodes a dictionary of types in the dictionary, given a key path, after which the transform will be applied.
    /// - Parameter keyPath: Array of strings.
    /// - Parameter transform: The transform to apply on the dictionary. Errors thrown here will fail decoding and be wrapped in a `DictionaryDecodingError`.
    /// - Returns: A transformed type.
    /// - Throws: A `DictionaryDecodingError`, a `KeyNotFoundError` if key was not found, or any other error that was encountered when trying to decode.
    func decode<T: Decodable, U>(_ keyPath: [JSONDictionary.Key], transform: (_ input: Dictionary<String, T>) throws -> U) throws -> U {
        let decodedJson = try self.decode(keyPath) as Dictionary<String, T>
        do {
            return try transform(decodedJson)
        } catch {
            // Catch any errors and wrap them, together with the key path.
            throw DictionaryDecodingError(keyPath: keyPath, underlyingError: error)
        }
    }

    /// Decodes an array of types in the dictionary, given a key path, after which the transform will be applied.
    /// - Parameter keyPath: Array of strings.
    /// - Parameter transform: The transform to apply on the array. Errors thrown here will fail decoding and be wrapped in a `DictionaryDecodingError`.
    /// - Returns: A transformed type.
    /// - Throws: A `DictionaryDecodingError`, a `KeyNotFoundError` if key was not found, or any other error that was encountered when trying to decode.
    func decode<T: Decodable, U>(_ keyPath: [JSONDictionary.Key], transform: (_ input: Array<T>) throws -> U) throws -> U {
        let decodedJson = try self.decode(keyPath) as Array<T>
        do {
            return try transform(decodedJson)
        } catch {
            // Catch any errors and wrap them, together with the key path.
            throw DictionaryDecodingError(keyPath: keyPath, underlyingError: error)
        }
    }
}

// MARK: Main methods for decoding optionals with key path

public extension JSONDictionary {
    /// Decodes a optional type in the dictionary, given a key path, after which the transform will be applied. Note that anything in the `transform`-closure will still be called, even if the value is `nil`
    /// - Parameter keyPath: Array of strings.
    /// - Parameter transform: The transform to apply on the type. Errors thrown here will fail decoding and be wrapped in a `DictionaryDecodingError`.
    /// - Returns: A transformed type.
    /// - Throws: A `DictionaryDecodingError`, or any other error that was encountered when trying to decode.
    func decode<T: Decodable, U>(_ keyPath: [JSONDictionary.Key], transform: (_ input: T?) throws -> U) throws -> U {
        let decodedJson = try self.decode(keyPath) as T?
        do {
            return try transform(decodedJson)
        } catch {
            // Catch any errors and wrap them, together with the key path.
            throw DictionaryDecodingError(keyPath: keyPath, underlyingError: error)
        }
    }
    
    /// Decodes a optional dictionary of types in the dictionary, given a key path, after which the transform will be applied. Note that anything in the `transform`-closure will still be called, even if the value is `nil`
    /// - Parameter keyPath: Array of strings.
    /// - Parameter transform: The transform to apply on the dictionary. Errors thrown here will fail decoding and be wrapped in a `DictionaryDecodingError`.
    /// - Returns: A transformed type.
    /// - Throws: A `DictionaryDecodingError`, or any other error that was encountered when trying to decode.
    func decode<T: Decodable, U>(_ keyPath: [JSONDictionary.Key], transform: (_ input: Dictionary<String, T>?) throws -> U) throws -> U {
        let decodedJson = try self.decode(keyPath) as Dictionary<String, T>?
        do {
            return try transform(decodedJson)
        } catch {
            // Catch any errors and wrap them, together with the key path.
            throw DictionaryDecodingError(keyPath: keyPath, underlyingError: error)
        }
    }

    /// Decodes an optional array of types in the dictionary, given a key path, after which the transform will be applied. Note that anything in the `transform`-closure will still be called, even if the value is `nil`
    /// - Parameter keyPath: Array of strings.
    /// - Parameter transform: The transform to apply on the array. Errors thrown here will fail decoding and be wrapped in a `DictionaryDecodingError`.
    /// - Returns: A transformed type.
    /// - Throws: A `DictionaryDecodingError`, or any other error that was encountered when trying to decode.
    func decode<T: Decodable, U>(_ keyPath: [JSONDictionary.Key], transform: (_ input: Array<T>?) throws -> U) throws -> U {
        let decodedJson = try self.decode(keyPath) as Array<T>?
        do {
            return try transform(decodedJson)
        } catch {
            // Catch any errors and wrap them, together with the key path.
            throw DictionaryDecodingError(keyPath: keyPath, underlyingError: error)
        }
    }
}

// MARK: Helper methods for decoding with key

public extension JSONDictionary {
    /// Decodes a type in the dictionary, given a key, after which the transform will be applied.
    /// - Parameter key: String.
    /// - Parameter transform: The transform to apply on the type. Errors thrown here will fail decoding and be wrapped in a `DictionaryDecodingError`.
    /// - Returns: A transformed type.
    /// - Throws: A `DictionaryDecodingError`, a `KeyNotFoundError` if key was not found, or any other error that was encountered when trying to decode.
    func decode<T: Decodable, U>(_ key: JSONDictionary.Key, transform: (_ input: T) throws -> U) throws -> U {
        return try self.decode([key], transform: transform)
    }
    
    /// Decodes a dictionary of types in the dictionary, given a key, after which the transform will be applied.
    /// - Parameter key: String.
    /// - Parameter transform: The transform to apply on the dictionary. Errors thrown here will fail decoding and be wrapped in a `DictionaryDecodingError`.
    /// - Returns: A transformed type.
    /// - Throws: A `DictionaryDecodingError`, a `KeyNotFoundError` if key was not found, or any other error that was encountered when trying to decode.
    func decode<T: Decodable, U>(_ key: JSONDictionary.Key, transform: (_ input: Dictionary<String, T>) throws -> U) throws -> U {
        return try self.decode([key], transform: transform)
    }
    
    /// Decodes an array of types in the dictionary, given a key, after which the transform will be applied.
    /// - Parameter key: String.
    /// - Parameter transform: The transform to apply on the array. Errors thrown here will fail decoding and be wrapped in a `DictionaryDecodingError`.
    /// - Returns: A transformed type.
    /// - Throws: A `DictionaryDecodingError`, a `KeyNotFoundError` if key was not found, or any other error that was encountered when trying to decode.
    func decode<T: Decodable, U>(_ key: JSONDictionary.Key, transform: (_ input: Array<T>) throws -> U) throws -> U {
        return try self.decode([key], transform: transform)
    }
}

// MARK: Helper methods for decoding optionals with key

public extension JSONDictionary {
    /// Decodes a optional type in the dictionary, given a key, after which the transform will be applied. Note that anything in the `transform`-closure will still be called, even if the value is `nil`
    /// - Parameter key: String.
    /// - Parameter transform: The transform to apply on the type. Errors thrown here will fail decoding and be wrapped in a `DictionaryDecodingError`.
    /// - Returns: A transformed type.
    /// - Throws: A `DictionaryDecodingError`, or any other error that was encountered when trying to decode.
    func decode<T: Decodable, U>(_ key: JSONDictionary.Key, transform: (_ input: T?) throws -> U) throws -> U {
        return try self.decode([key], transform: transform)
    }
    
    /// Decodes a optional dictionary of types in the dictionary, given a key, after which the transform will be applied. Note that anything in the `transform`-closure will still be called, even if the value is `nil`
    /// - Parameter key: String.
    /// - Parameter transform: The transform to apply on the dictionary. Errors thrown here will fail decoding and be wrapped in a `DictionaryDecodingError`.
    /// - Returns: A transformed type.
    /// - Throws: A `DictionaryDecodingError`, or any other error that was encountered when trying to decode.
    func decode<T: Decodable, U>(_ key: JSONDictionary.Key, transform: (_ input: Dictionary<String, T>?) throws -> U) throws -> U {
        return try self.decode([key], transform: transform)
    }
    
    /// Decodes a optional array of types in the dictionary, given a key, after which the transform will be applied. Note that anything in the `transform`-closure will still be called, even if the value is `nil`
    /// - Parameter key: String.
    /// - Parameter transform: The transform to apply on the array. Errors thrown here will fail decoding and be wrapped in a `DictionaryDecodingError`.
    /// - Returns: A transformed type.
    /// - Throws: A `DictionaryDecodingError`, or any other error that was encountered when trying to decode.
    func decode<T: Decodable, U>(_ key: JSONDictionary.Key, transform: (_ input: Array<T>?) throws -> U) throws -> U {
        return try self.decode([key], transform: transform)
    }
}
