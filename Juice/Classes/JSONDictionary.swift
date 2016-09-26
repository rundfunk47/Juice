//
//  JSONDictionary.swift
//  Juice
//
//  Created by Narek M on 19/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

public typealias JSONConformingDictionary = Dictionary<JSONDictionary.Key, JSONDictionary.Value>

/// A dictionary where all keys are strings and all values conform to `JSON`.
/// Workaround since we can't restrict protocol conformance to type-constrained extensions.
public struct JSONDictionary {
    public typealias Key = String
    public typealias Value = JSON
    public typealias Element = (Key, Value)
    
    fileprivate var _dictionary: JSONConformingDictionary

    public init(_ dictionary: JSONConformingDictionary = JSONConformingDictionary()) {
        self._dictionary = dictionary
    }
}

// MARK: CustomStringConvertible conformance

extension JSONDictionary: CustomStringConvertible {
    public var description: String {
        return _dictionary.description
    }
}

// MARK: CustomDebugStringConvertible conformance

extension JSONDictionary: CustomDebugStringConvertible {
    public var debugDescription: String {
        return _dictionary.debugDescription
    }
}

// MARK: CollectionType conformance

extension JSONDictionary: Collection {
    public typealias Iterator = DictionaryIterator<Key, Value>
    public typealias Index = DictionaryIndex<Key, Value>
    
    public func index(after i: DictionaryIndex<JSONDictionary.Key, JSONDictionary.Value>) -> DictionaryIndex<JSONDictionary.Key, JSONDictionary.Value> {
        return _dictionary.index(after: i)
    }

    public func makeIterator() -> JSONDictionary.Iterator {
        return _dictionary.makeIterator()
    }
    
    public var startIndex: JSONDictionary.Index {
        return _dictionary.startIndex
    }
    
    public var endIndex: JSONDictionary.Index {
        return _dictionary.endIndex
    }
    
    public subscript(key: Index)->Iterator.Element {
        return _dictionary[key]
    }
    
    internal subscript(key: Key)->Value? {
        get {
            return _dictionary[key]
        } set {
            _dictionary[key] = newValue
        }
    }
}

// MARK: Useful extensions

extension JSONDictionary {
    /// Applies a map on the values in a given `JSONDictionary`. Shamelessly stolen from http://stackoverflow.com/questions/24116271/whats-the-cleanest-way-of-applying-map-to-a-dictionary-in-swift
    func map<OutValue>(_ transform: @escaping (Value) throws -> OutValue) rethrows -> [Key: OutValue] {
        return Dictionary<Key, OutValue>(try map { (k, v) in (k, try transform(v)) })
    }    
}

public extension JSONDictionary {
    /// Digs through the dictionary to return a value
    /// - Parameter keyPath: Array of strings, the first represents the first key, the second the second key and so on.
    /// - Returns: The `JSON` found. Returns nil if it couldn't be found.
    public subscript(keyPath: [JSONDictionary.Key])->JSONDictionary.Value? {
        get {
            var json : JSONDictionary.Value? = self
            for key in keyPath {
                json = (json as? JSONDictionary)?[key]
            }
            return json
        }
    }
}

extension JSONDictionary {
    /// Returns the dictionary with values that are AnyObject, for usage by networking code
    /// - Returns: The dictionary with values that are AnyObject
    public func toLooselyTypedDictionary()->Dictionary<String, AnyObject> {
        return self.map({$0.toLooselyTypedObject()})
    }
}
