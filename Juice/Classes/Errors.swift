//
//  Errors.swift
//  Juice
//
//  Created by Narek M on 19/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

private func typeNameForType(_ thing: Any)->String {
    return String(describing: thing)
}

private func typeNameForValue(_ thing: Any)->String {
    return String(describing: Mirror(reflecting: thing).subjectType)
}

/// Thrown when a non-optional property with a certain key or key path was not found in the `JSONDictionary`.
open class KeyNotFoundError: Error {
    public var localizedDescription: String {
        return "Key not found."
    }
}

/// Helper to append some text
private func extraText(_ text: String?)->String {
    if let extraText = text {
        return ": " + extraText
    } else {
        return "."
    }
}

/// Mismatch-errors that can be thrown when decoding
public enum MismatchError: Error {
    /// Thrown when a certain `JSON` was expected in the initializer, but another one was given instead.
    case typeMismatch(expected: Any, got: JSON)
    /// Thrown when a enum-value could not be mapped, according to its RawValue
    case unmappedEnum(got: JSON)
    
    public var localizedDescription: String {
        switch self {
        case .typeMismatch(let expected, let got):
            return "Expected \"" + typeNameForType(expected) + "\" got \"" + typeNameForValue(got) + "\" with value " + got.jsonString + "."
        case .unmappedEnum(let got):
            return "Enum couldn't be mapped with gotten value " + got.jsonString + "."
        }
    }
}

/// Thrown if the `decode` method of a `JSONDictionary` failed.
public struct DictionaryDecodingError: Error {
    /// Path to the key where the decoding failed.
    var keyPath: [String]
    /// The actual error that was thrown when calling the `decode`-method.
    public var underlyingError : Error
    
    public var localizedDescription: String {
        return "Error at key path " + keyPath.description + extraText(underlyingError.localizedDescription)
    }
}

/// Thrown if the type could not be decoded.
public struct TypeDecodingError: Error {
    /// The type which was attempted to be decoded.
    var type: Any
    /// The actual error that was thrown when attempting to decode.
    public var underlyingError : Error
    
    public var localizedDescription: String {
        return "Failure when attempting to decode type " + typeNameForType(type) + extraText(underlyingError.localizedDescription)
    }
}
