//
//  JSONDictionary+Encode.swift
//  Juice
//
//  Created by Narek M on 26/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

import Foundation

/// Yay recursive~ :3
private func doOnDictionary(_ dict: JSONDictionary, keyPath: [String], closure: (_ dictionary: inout JSONDictionary, _ key: String) throws -> ()) throws -> JSONDictionary {
    if let key = keyPath.first , keyPath.count == 1 {
        var copyDict = dict
        try closure(&copyDict, key)
        return copyDict
    } else {
        var copyKeyPath = keyPath
        let firstKey = copyKeyPath.removeFirst()
        var copyDict = dict
        
        if let jsonDictionaryValueForKey = copyDict[firstKey] as? JSONDictionary {
            copyDict[firstKey] = try doOnDictionary(jsonDictionaryValueForKey, keyPath: copyKeyPath, closure: closure)
            return copyDict
        } else {
            copyDict[firstKey] = try doOnDictionary(JSONDictionary(), keyPath: copyKeyPath, closure: closure)
            return copyDict
        }
    }
}

public extension JSONDictionary {
    /// Encodes a type in the dictionary, given a keypath.
    /// - Parameter keyPath: Array of strings.
    /// - Parameter value: What to encode.
    mutating func encode<T:Encodable>(_ keyPath: [String], value: T?) throws {
        guard let val = value else {return}
        self = try doOnDictionary(self, keyPath: keyPath, closure: {(dictionary, key) in dictionary[key] = try val.encode()})
    }
    
    /// Encodes a type in the dictionary, given a keypath.
    /// - Parameter keyPath: Array of strings.
    /// - Parameter value: What to encode.
    mutating func encode<T:Encodable>(_ keyPath: [String], value: Array<T>?) throws {
        guard let val = value else {return}
        self = try doOnDictionary(self, keyPath: keyPath, closure: {
            (dictionary, key) in
            dictionary[key] = JSONArray(try val.map({try $0.encode()}))
        })
    }
    
    /// Encodes a type in the dictionary, given a keypath.
    /// - Parameter keyPath: Array of strings.
    /// - Parameter value: What to encode.
    mutating func encode<T:Encodable>(_ keyPath: [String], value: Dictionary<String, T>?) throws {
        guard let val = value else {return}
        self = try doOnDictionary(self, keyPath: keyPath, closure: {
            (dictionary, key) in
            dictionary[key] = JSONDictionary(try val.map({try $0.encode()}))
        })
    }
    
    /// Encodes a type in the dictionary, given a keypath.
    /// - Parameter keyPath: Array of strings.
    /// - Parameter value: What to encode.
    mutating func encode<T:Encodable>(_ keyPath: [String], value: Array<T?>?) throws {
        guard let val = value else {return}
        self = try doOnDictionary(self, keyPath: keyPath, closure: {
            (dictionary, key) in
            dictionary[key] = JSONArray(try val.filter{$0 != nil}.map{try $0!.encode()})
        })
    }
    
    /// Encodes a type in the dictionary, given a keypath.
    /// - Parameter keyPath: Array of strings.
    /// - Parameter value: What to encode.
    mutating func encode<T:Encodable>(_ keyPath: [String], value: Dictionary<String, T?>?) throws {
        guard let val = value else {return}
        self = try doOnDictionary(self, keyPath: keyPath, closure: {
            (dictionary, key) in
            dictionary[key] = JSONDictionary(try val.filter{$0.value != nil}.map{try $0!.encode()})
        })
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Parameter value: What to encode.
    mutating func encode<T:Encodable>(_ key: String, value: T?) throws {
        try self.encode([key], value: value)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Parameter value: What to encode.
    mutating func encode<T:Encodable>(_ key: String, value: Array<T>?) throws {
        try self.encode([key], value: value)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Parameter value: What to encode.
    mutating func encode<T:Encodable>(_ key: String, value: Dictionary<String, T>?) throws {
        try self.encode([key], value: value)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Parameter value: What to encode.
    mutating func encode<T:Encodable>(_ key: String, value: Array<T?>?) throws {
        try self.encode([key], value: value)
    }
    
    /// Encodes a type in the dictionary, given a key.
    /// - Parameter key: String.
    /// - Parameter value: What to encode.
    mutating func encode<T:Encodable>(_ key: String, value: Dictionary<String, T?>?) throws {
        try self.encode([key], value: value)
    }
}
