import Foundation
import CryptoKit

public class NVMCrypto {
    
    public static func encrypt(_ data: Data, with cryptKeys: NVMCryptKeys = NVMCryptKeys.generated(),
                               encoding: String.Encoding? = nil) throws -> NVMCryptResult {
        
        let sealedBox = try AES.GCM.seal(data, using: cryptKeys.getSymmetricKey())
        let sealedBoxData = sealedBox.combined!

        return NVMCryptResult(data: sealedBoxData, with: cryptKeys, encoding: encoding)
    }
    
    public static func decrypt(_ data: Data, with cryptKeys: NVMCryptKeys) throws -> Data {
        
        let BSharedSecret = try cryptKeys.privateKey.sharedSecretFromKeyAgreement(with: cryptKeys.publicKey)
        let BSymmetricKey = BSharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self, salt: cryptKeys.salt, sharedInfo: Data(), outputByteCount: 32)
        
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: BSymmetricKey)
            
        return decryptedData
    }
}

public extension NVMCrypto {
    
    static func encryptString(_ string: String, with cryptKeys: NVMCryptKeys = NVMCryptKeys.generated(),
                                     encoding: String.Encoding = .utf8) throws -> NVMCryptResult {
        
        return try self.encrypt(string.data(using: .utf8)!, with: cryptKeys, encoding: encoding)
    }
    
    static func decryptString(_ data: Data, with cryptKeys: NVMCryptKeys, encoding: String.Encoding = .utf8) throws -> String {
        
        return String(data: try self.decrypt(data, with: cryptKeys), encoding: encoding)!
    }
    
    static func decryptString(_ nvmCryptResult: NVMCryptResult) throws -> String {
        
        return String(data: try self.decrypt(nvmCryptResult.data, with: nvmCryptResult.cryptKeys), encoding: nvmCryptResult.stringEncoding)!
    }
}
