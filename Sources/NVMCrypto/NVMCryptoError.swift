//
//  NVMCryptoError.swift
//  
//
//  Created by Damian Van de Kauter on 27/05/2023.
//

import Foundation

public enum NVMCryptoError: Error {
    case base64EncodingFailed
    case dataEncodingFailed
    case stingEncodingFailed
}

public enum NVMCryptResultError: Error {
    case invalidKey
}

extension NVMCryptoError: LocalizedError {
    public var errorCode: Int {
        switch self {
        case .base64EncodingFailed:
            return 1
        case .dataEncodingFailed:
            return 2
        case .stingEncodingFailed:
            return 3
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .base64EncodingFailed:
            return NSLocalizedString(
                "Base64 encoding failed.",
                comment: ""
            )
        case .dataEncodingFailed:
            return NSLocalizedString(
                "Data encoding failed.",
                comment: ""
            )
        case .stingEncodingFailed:
            return NSLocalizedString(
                "String encoding failed.",
                comment: ""
            )
        }
    }
}

extension NVMCryptResultError: LocalizedError {
    public var errorCode: Int {
        switch self {
        case .invalidKey:
            return 1
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .invalidKey:
            return NSLocalizedString(
                "There valid key defined in this NVMCryptResult.",
                comment: ""
            )
        }
    }
}
