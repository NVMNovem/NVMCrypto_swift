//
//  NVMCryptKeys.swift
//  
//
//  Created by Damian Van de Kauter on 24/05/2023.
//

import Foundation
import CryptoKit

public struct NVMCryptKeys {
    
    public let privateKey: P521.KeyAgreement.PrivateKey
    public let publicKey: P521.KeyAgreement.PublicKey
    public let salt: Data
    
    public init(privateKey: P521.KeyAgreement.PrivateKey,
                publicKey: P521.KeyAgreement.PublicKey,
                salt: Data) {
        self.privateKey = privateKey
        self.publicKey = publicKey
        self.salt = salt
    }
    
    public init?(privateKey: String,
                 publicKey: String,
                 salt: String) {
        if let privateKeyData = Data(base64Encoded: privateKey),
           let publicKeyData = Data(base64Encoded: publicKey),
           let saltData = Data(base64Encoded: salt) {
            if let privateKey = try? P521.KeyAgreement.PrivateKey(rawRepresentation: privateKeyData),
               let publicKey = try? P521.KeyAgreement.PublicKey(rawRepresentation: publicKeyData) {
                self.privateKey = privateKey
                self.publicKey = publicKey
                self.salt = saltData
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    public init() {
        let symmetricKey = SymmetricKey(size: .bits256)
        let salt = symmetricKey.withUnsafeBytes { Data($0) }

        let generatedPrivateKey = P521.KeyAgreement.PrivateKey()
        let generatedPublicKey = generatedPrivateKey.publicKey
        
        self.privateKey = generatedPrivateKey
        self.publicKey = generatedPublicKey
        self.salt = salt
    }
}

public extension NVMCryptKeys {
    
    static func generated() -> Self {
        return NVMCryptKeys()
    }
}

public extension NVMCryptKeys {
    
    func getSymmetricKey() throws -> SymmetricKey {
        let sharedSecret = try privateKey.sharedSecretFromKeyAgreement(with: publicKey)
        let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self, salt: salt, sharedInfo: Data(), outputByteCount: 32)
        return symmetricKey
    }
    
    func getSymmetricString() throws -> String {
        return try self.getSymmetricKey().withUnsafeBytes {
            Data($0).base64EncodedString()
        }
    }
}

public extension NVMCryptKeys {
    
    var privateKeyString: String {
        return self.privateKey.rawRepresentation.base64EncodedString()
    }
    
    var publicKeyString: String {
        return self.publicKey.rawRepresentation.base64EncodedString()
    }
    
    var saltString: String {
        return self.salt.base64EncodedString()
    }
}

public extension SymmetricKey {
    
    init(password: String) throws {
        guard let data = Data(base64Encoded: password) else {
            throw NVMCryptoError.dataEncodingFailed
        }
        
        self.init(data: data)
    }
}
