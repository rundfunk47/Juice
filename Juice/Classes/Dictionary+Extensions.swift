//
//  Dictionary+Extensions.swift
//  Juice
//
//  Created by Narek M on 19/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

extension Dictionary {
    /// Initializes dictionary with an array of two-tuples. Shamelessly stolen from http://stackoverflow.com/questions/24116271/whats-the-cleanest-way-of-applying-map-to-a-dictionary-in-swift
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
}

extension Dictionary {
    /// Applies a map on the values in a given `Dictionary`. Shamelessly stolen from http://stackoverflow.com/questions/24116271/whats-the-cleanest-way-of-applying-map-to-a-dictionary-in-swift
    func map<OutValue>(_ transform: (Value) throws -> OutValue) rethrows -> [Key: OutValue] {
        return Dictionary<Key, OutValue>(try map { let (k, v) = $0; return (k, try transform(v)) })
    }
    
    /// Applies a filter on the values in a given `Dictionary`.
    func filter(_ includeElement: (Element) throws -> Bool) rethrows -> [Key : Value] {
        return Dictionary(try self.filter(includeElement))
    }
}
