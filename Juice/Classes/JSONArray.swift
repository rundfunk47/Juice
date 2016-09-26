//
//  JSONArray.swift
//  Juice
//
//  Created by Narek M on 19/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

public typealias JSONConformingArray = Array<JSON>

/// An array where all elements conform to `JSON`.
/// Workaround since we can't restrict protocol conformance to type-constrained extensions.
public struct JSONArray {
    fileprivate var _elements: JSONConformingArray
    
    public init(_ array: JSONConformingArray = JSONConformingArray()) {
        self._elements = array
    }
}

// MARK: CustomStringConvertible conformance

extension JSONArray: CustomStringConvertible {
    public var description: String {
        return _elements.description
    }
}

// MARK: CustomDebugStringConvertible conformance

extension JSONArray: CustomDebugStringConvertible {
    public var debugDescription: String {
        return _elements.debugDescription
    }
}

// MARK: CollectionType conformance

extension JSONArray : Collection {
    public func index(after i: Int) -> Int {
        return _elements.index(after: i)
    }
    
    public func makeIterator() -> IndexingIterator<JSONConformingArray> {
        return _elements.makeIterator()
    }
    
    public var startIndex: JSONConformingArray.Index {
        return _elements.startIndex
    }
    
    public var endIndex: JSONConformingArray.Index {
        return _elements.endIndex
    }
    
    public subscript(i: Int)-> JSON {
        return _elements[i]
    }
}
