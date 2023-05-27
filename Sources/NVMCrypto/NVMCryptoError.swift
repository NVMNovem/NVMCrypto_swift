//
//  NVMCryptoError.swift
//  
//
//  Created by Damian Van de Kauter on 27/05/2023.
//

import Foundation

public enum NVMCryptoError: Error {
    case dataEncodingFailed
    case stingEncodingFailed
}

public enum NVMCryptResultError: Error {
    case invalidKey
}

extension NVMCryptoError: LocalizedError {
    public var errorCode: Int {
        switch self {
        case .dataEncodingFailed:
            return 1
        case .stingEncodingFailed:
            return 2
        }
    }
    
    public var errorDescription: String? {
        switch self {
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
