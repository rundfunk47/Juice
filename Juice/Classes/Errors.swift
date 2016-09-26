//
//  Errors.swift
//  Juice
//
//  Created by Narek M on 19/06/16.
//  Copyright © 2016 Narek. All rights reserved.
//

private let JuiceErrorDomain = "JuiceErrorDomain"
public let JuiceKeyNotFound = 1
public let JuiceTypeMismatch = 2
public let JuiceUnmappedEnum = 3
public let JuiceDictionaryDecodingError = 4
public let JuiceTypeDecodingError = 5

private func typeNameForType(_ thing: Any)->String {
    return String(describing: thing)
}

private func typeNameForValue(_ thing: Any)->String {
    return String(describing: Mirror(reflecting: thing).subjectType)
}

/// Thrown when a non-optional property with a certain key or key path was not found in the `JSONDictionary`.
open class KeyNotFoundError: Error, CustomStringConvertible, CustomDebugStringConvertible, CustomNSError {
    /// The user-info dictionary.
    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: description]
    }
    
    /// The error code within the given domain.
    public var errorCode: Int {
        return JuiceKeyNotFound
    }
    
    /// The domain of the error.
    public static var errorDomain = JuiceErrorDomain

    open var description: String {
        return "Key not found."
    }
    
    open var debugDescription: String {
        return self.description
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
public enum MismatchError: Error , CustomStringConvertible, CustomDebugStringConvertible, CustomNSError {
    /// The user-info dictionary.
    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: description]
    }
    
    /// The error code within the given domain.
    public var errorCode: Int {
        switch self {
        case .typeMismatch(_, _):
            return JuiceTypeMismatch
        case .unmappedEnum(_):
            return JuiceUnmappedEnum
        }
    }
    
    /// The domain of the error.
    public static var errorDomain = JuiceErrorDomain
    
    
    /// Thrown when a certain `JSON` was expected in the initializer, but another one was given instead.
    case typeMismatch(expected: Any, got: JSON)
    /// Thrown when a enum-value could not be mapped, according to its RawValue
    case unmappedEnum(got: JSON)
    
    public var description: String {
        switch self {
        case .typeMismatch(let expected, let got):
            return "Expected \"" + typeNameForType(expected) + "\" got \"" + typeNameForValue(got) + "\"."
        case .unmappedEnum(_):
            return "Enum couldn't be mapped."
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .typeMismatch(let expected, let got):
            return "Expected \"" + typeNameForType(expected) + "\" got \"" + typeNameForValue(got) + "\" with value " + got.jsonString + "."
        case .unmappedEnum(let got):
            return "Enum couldn't be mapped with gotten value " + got.jsonString + "."
        }
    }
}

/// Thrown if the `decode` method of a `JSONDictionary` failed.
public struct DictionaryDecodingError: Error, CustomStringConvertible, CustomDebugStringConvertible, CustomNSError {
    /// The user-info dictionary.
    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: shortDescription + ".", NSUnderlyingErrorKey: underlyingError as NSError]
    }
    
    /// The error code within the given domain.
    public var errorCode: Int {
        return JuiceDictionaryDecodingError
    }
    
    /// The domain of the error.
    public static var errorDomain = JuiceErrorDomain
    
    /// Path to the key where the decoding failed.
    var keyPath: [String]
    /// The actual error that was thrown when calling the `decode`-method.
    public var underlyingError : Error
    
    public var description: String {
        return shortDescription + extraText((underlyingError as? CustomStringConvertible)?.description)
    }
    
    public var debugDescription: String {
        return shortDescription + extraText((underlyingError as? CustomDebugStringConvertible)?.debugDescription)
    }
    
    private var shortDescription: String {
        return "Error at key path " + keyPath.description
    }
}

/// Thrown if the type could not be decoded.
public struct TypeDecodingError: Error, CustomStringConvertible, CustomDebugStringConvertible, CustomNSError {
    /// The user-info dictionary.
    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: shortDescription + ".", NSUnderlyingErrorKey: underlyingError as NSError]
    }
    
    /// The error code within the given domain.
    public var errorCode: Int {
        return JuiceTypeDecodingError
    }
    
    /// The domain of the error.
    public static var errorDomain = JuiceErrorDomain

    /// The type which was attempted to be decoded.
    var type: Any
    /// The actual error that was thrown when attempting to decode.
    public var underlyingError : Error
    
    public var description: String {
        return shortDescription + extraText((underlyingError as? CustomStringConvertible)?.description)
    }
    
    public var debugDescription: String {
        return shortDescription + extraText((underlyingError as? CustomDebugStringConvertible)?.debugDescription)
    }
    
    private var shortDescription: String {
        return "Failure when attempting to decode type " + typeNameForType(type)
    }
}
