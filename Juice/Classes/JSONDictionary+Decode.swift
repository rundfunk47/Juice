//
//  JSONDictionary+Decode.swift
//  Juice
//
//  Created by Narek M on 19/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

// MARK: Main methods to decode given a key path

public extension JSONDictionary {
    /// Decodes a type in the dictionary, given a key path.
    /// - Parameter keyPath: Array of strings.
    /// - Returns: The decoded type.
    /// - Throws: A `DictionaryDecodingError`, a `KeyNotFoundError` if key was not found, or any other error that was encountered when trying to decode.
    func decode<T: FactoryDecodable>(_ keyPath: [JSONDictionary.Key]) throws -> T {
        do {
            if let json = self[keyPath] {
                return try T.create(fromJsonCandidate: json)
            } else {
                throw KeyNotFoundError() as Error
            }
        } catch {
            // Catch any errors and wrap them, together with the key path.
            throw DictionaryDecodingError(keyPath: keyPath, underlyingError: error)
        }
    }
    
    /// Decodes a dictionary of types in the dictionary, given a key path.
    /// - Parameter keyPath: Array of strings.
    /// - Returns: The decoded type.
    /// - Throws: A `DictionaryDecodingError`, a `KeyNotFoundError` if key was not found, or any other error that was encountered when trying to decode.
    func decode<T: FactoryDecodable>(_ keyPath: [JSONDictionary.Key]) throws -> Dictionary<String, T> {
        do {
            if let json = self[keyPath] {
                return try JSONDictionary(fromJsonCandidate: json).mapPairs({
                    try ($0.key, T.create(fromJsonCandidate: $0.value))
                })
            } else {
                throw KeyNotFoundError() as Error
            }
        } catch {
            // Catch any errors and wrap them, together with the key path.
            throw DictionaryDecodingError(keyPath: keyPath, underlyingError: error)
        }
    }
    
    /// Decodes an array of types in the dictionary, given a key path.
    /// - Parameter keyPath: Array of strings.
    /// - Returns: The decoded type.
    /// - Throws: A `DictionaryDecodingError`, a `KeyNotFoundError` if key was not found, or any other error that was encountered when trying to decode.
    func decode<T: FactoryDecodable>(_ keyPath: [JSONDictionary.Key]) throws -> Array<T> {
        do {
            if let json = self[keyPath] {
                return try JSONArray(fromJsonCandidate: json).map({
                    try T.create(fromJsonCandidate: $0)
                })
            } else {
                throw KeyNotFoundError() as Error
            }
        } catch {
            // Catch any errors and wrap them, together with the key path.
            throw DictionaryDecodingError(keyPath: keyPath, underlyingError: error)
        }
    }
}

// MARK: Helper methods for decoding optionals with key path

public extension JSONDictionary {
    /// Decodes a type in the dictionary, given a key path.
    /// - Parameter keyPath: Array of strings.
    /// - Returns: The decoded type, or nil if the key was not found in dictionary.
    /// - Throws: A `DictionaryDecodingError`, or any other error that was encountered when trying to decode.
    func decode<T: FactoryDecodable>(_ keyPath: [JSONDictionary.Key]) throws -> T? {
        do {
            return try self.decode(keyPath) as T
        } catch let error as DictionaryDecodingError where error.underlyingError is KeyNotFoundError {
            return nil
        }
    }
    
    /// Decodes a dictionary of types in the dictionary, given a key path.
    /// - Parameter keyPath: Array of strings.
    /// - Returns: The decoded type, or nil if the key was not found in dictionary.
    /// - Throws: A `DictionaryDecodingError`, or any other error that was encountered when trying to decode.
    func decode<T: FactoryDecodable>(_ keyPath: [JSONDictionary.Key]) throws -> Dictionary<String, T>? {
        do {
            return try self.decode(keyPath) as Dictionary<String,T>
        } catch let error as DictionaryDecodingError where error.underlyingError is KeyNotFoundError {
            return nil
        }
    }
    
    /// Decodes an array of types in the dictionary, given a key path.
    /// - Parameter keyPath: Array of strings.
    /// - Returns: The decoded type, or nil if the key was not found in dictionary.
    /// - Throws: A `DictionaryDecodingError`, or any other error that was encountered when trying to decode.
    func decode<T: FactoryDecodable>(_ keyPath: [JSONDictionary.Key]) throws -> Array<T>? {
        do {
            return try self.decode(keyPath) as Array<T>
        } catch let error as DictionaryDecodingError where error.underlyingError is KeyNotFoundError {
            return nil
        }
    }
}

// MARK: Helper methods for decoding with key

public extension JSONDictionary {
    /// Decodes a type in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Returns: The decoded type.
    /// - Throws: A `DictionaryDecodingError`, a `KeyNotFoundError` if key was not found, or any other error that was encountered when trying to decode.
    func decode<T: FactoryDecodable>(_ key: JSONDictionary.Key) throws -> T {
        return try self.decode([key]) as T
    }
    
    /// Decodes a dictionary of types in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Returns: The decoded type.
    /// - Throws: A `DictionaryDecodingError`, a `KeyNotFoundError` if key was not found, or any other error that was encountered when trying to decode.
    func decode<T: FactoryDecodable>(_ key: JSONDictionary.Key) throws -> Dictionary<String, T> {
        return try self.decode([key]) as Dictionary<String, T>
    }
    
    /// Decodes an array of types in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Returns: The decoded type.
    /// - Throws: A `DictionaryDecodingError`, a `KeyNotFoundError` if key was not found, or any other error that was encountered when trying to decode.
    func decode<T: FactoryDecodable>(_ key: JSONDictionary.Key) throws -> Array<T> {
        return try self.decode([key]) as Array<T>
    }
}

// MARK: Helper methods for decoding optionals with key

public extension JSONDictionary {
    /// Decodes a type in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Returns: The decoded type, or nil if the key was not found in dictionary.
    /// - Throws: A `DictionaryDecodingError`, or any other error that was encountered when trying to decode.
    func decode<T: FactoryDecodable>(_ key: JSONDictionary.Key) throws -> T? {
        return try self.decode([key]) as T?
    }
    
    /// Decodes a dictionary of types in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Returns: The decoded type, or nil if the key was not found in dictionary.
    /// - Throws: A `DictionaryDecodingError`, or any other error that was encountered when trying to decode.
    func decode<T: FactoryDecodable>(_ key: JSONDictionary.Key) throws -> Dictionary<String, T>? {
        return try self.decode([key]) as Dictionary<String, T>?
    }
    
    /// Decodes an array of types in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Returns: The decoded type, or nil if the key was not found in dictionary.
    /// - Throws: A `DictionaryDecodingError`, or any other error that was encountered when trying to decode.
    func decode<T: FactoryDecodable>(_ key: JSONDictionary.Key) throws -> Array<T>? {
        return try self.decode([key]) as Array<T>?
    }
}
