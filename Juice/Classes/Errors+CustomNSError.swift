//
//  Errors+CustomNSError.swift
//  Pods
//
//  Created by Narek M on 02/10/16.
//
//

private let JuiceErrorDomain = "JuiceErrorDomain"
public let JuiceKeyNotFound = 1
public let JuiceTypeMismatch = 2
public let JuiceUnmappedEnum = 3
public let JuiceDictionaryDecodingError = 4
public let JuiceTypeDecodingError = 5
public let JuiceKeyIsNull = 6

import Foundation

extension KeyIsNullError: CustomNSError {
    /// The user-info dictionary.
    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: localizedDescription]
    }
    
    /// The error code within the given domain.
    public var errorCode: Int {
        return JuiceKeyIsNull
    }
    
    /// The domain of the error.
    public static var errorDomain = JuiceErrorDomain
}

extension KeyNotFoundError: CustomNSError {
    /// The user-info dictionary.
    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: localizedDescription]
    }
    
    /// The error code within the given domain.
    public var errorCode: Int {
        return JuiceKeyNotFound
    }
    
    /// The domain of the error.
    public static var errorDomain = JuiceErrorDomain
}

extension MismatchError: CustomNSError {
    /// The user-info dictionary.
    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: localizedDescription]
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
}

extension DictionaryDecodingError: CustomNSError {
    /// The user-info dictionary.
    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: localizedDescription, NSUnderlyingErrorKey: underlyingError as NSError]
    }
    
    /// The error code within the given domain.
    public var errorCode: Int {
        return JuiceDictionaryDecodingError
    }
    
    /// The domain of the error.
    public static var errorDomain = JuiceErrorDomain
}

extension TypeDecodingError: CustomNSError {
    /// The user-info dictionary.
    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: localizedDescription, NSUnderlyingErrorKey: underlyingError as NSError]
    }
    
    /// The error code within the given domain.
    public var errorCode: Int {
        return JuiceTypeDecodingError
    }
    
    /// The domain of the error.
    public static var errorDomain = JuiceErrorDomain
}
