import Foundation
import CryptoKit

public class NVMCrypto<T : Codable> {
    
    /**
     Encrypt data using `NVMCryptKeys`
     */
    public static func encrypt(_ value: T, with cryptKeys: NVMCryptKeys = NVMCryptKeys.generated()) throws -> NVMCryptResult {
        
        if let dataValue = value as? Data {
            return try dataValue.seal(using: cryptKeys)
        } else {
            let encodedValue = try self.nvmEncode(value)
            return try encodedValue.seal(using: cryptKeys)
        }
    }
    
    /**
     Decrypt data using `NVMCryptKeys`
     */
    public static func decrypt(_ type: T.Type, data: Data, with cryptKeys: NVMCryptKeys) throws -> T {
        
        if type == Data.self {
            return try data.open(using: try cryptKeys.getSymmetricKey()) as! T
        } else {
            let decryptedData = try data.open(using: try cryptKeys.getSymmetricKey())
            return try self.nvmDecode(type, data: decryptedData)
        }
    }
    
    /**
     Decrypt data string using `NVMCryptKeys`
     */
    public static func decrypt(_ type: T.Type, dataString: String, with cryptKeys: NVMCryptKeys) throws -> T {
        
        guard let data = Data(base64Encoded: dataString) else {
            throw NVMCryptoError.base64EncodingFailed
        }
        if type == Data.self {
            return try data.open(using: try cryptKeys.getSymmetricKey()) as! T
        } else {
            let decryptedData = try data.open(using: try cryptKeys.getSymmetricKey())
            return try self.nvmDecode(type, data: decryptedData)
        }
    }
    
    
    /**
     Encrypt data using `SymmetricKey`
     */
    public static func encrypt(_ value: T, with symmetricKey: SymmetricKey) throws -> NVMCryptResult {
        
        if let dataValue = value as? Data {
            return try dataValue.seal(using: symmetricKey)
        } else {
            let encodedValue = try self.nvmEncode(value)
            return try encodedValue.seal(using: symmetricKey)
        }
    }
    
    /**
     Decrypt data using `SymmetricKey`
     */
    public static func decrypt(_ type: T.Type, data: Data, with symmetricKey: SymmetricKey) throws -> T {
        
        if type == Data.self {
            return try data.open(using: symmetricKey) as! T
        } else {
            let decryptedData = try data.open(using: symmetricKey)
            return try self.nvmDecode(type, data: decryptedData)
        }
    }
    
    /**
     Decrypt data string using `SymmetricKey`
     */
    public static func decrypt(_ type: T.Type, dataString: String, with symmetricKey: SymmetricKey) throws -> T {
        
        guard let data = Data(base64Encoded: dataString) else {
            throw NVMCryptoError.base64EncodingFailed
        }
        if type == Data.self {
            return try data.open(using: symmetricKey) as! T
        } else {
            let decryptedData = try data.open(using: symmetricKey)
            return try self.nvmDecode(type, data: decryptedData)
        }
    }
    
    
    /**
     Encrypt data using `Password`
     */
    public static func encrypt(_ value: T, with password: String) throws -> NVMCryptResult {
        
        if let dataValue = value as? Data {
            return try dataValue.seal(using: try SymmetricKey(password: password))
        } else {
            let encodedValue = try self.nvmEncode(value)
            return try encodedValue.seal(using: try SymmetricKey(password: password))
        }
    }
    
    /**
     Decrypt data using `Password`
     */
    public static func decrypt(_ type: T.Type, data: Data, with password: String) throws -> T {
        
        if type == Data.self {
            return try data.open(using: try SymmetricKey(password: password)) as! T
        } else {
            let decryptedData = try data.open(using: try SymmetricKey(password: password))
            return try self.nvmDecode(type, data: decryptedData)
        }
    }
    
    /**
     Decrypt data string using `Password`
     */
    public static func decrypt(_ type: T.Type, dataString: String, with password: String) throws -> T {
        
        guard let data = Data(base64Encoded: dataString) else {
            throw NVMCryptoError.base64EncodingFailed
        }
        if type == Data.self {
            return try data.open(using: try SymmetricKey(password: password)) as! T
        } else {
            let decryptedData = try data.open(using: try SymmetricKey(password: password))
            return try self.nvmDecode(type, data: decryptedData)
        }
    }
    
    
    /**
     Decrypt data from `NVMCryptResult`
     */
    public static func decrypt(_ type: T.Type, from nvmCryptResult: NVMCryptResult) throws -> T {
        
        if type == Data.self {
            if let cryptKeys = nvmCryptResult.cryptKeys {
                return try nvmCryptResult.data.open(using: try cryptKeys.getSymmetricKey()) as! T
            } else if let symmetricKey = nvmCryptResult.symmetricKey {
                return try nvmCryptResult.data.open(using: symmetricKey) as! T
            } else {
                throw NVMCryptResultError.invalidKey
            }
        } else {
            if let cryptKeys = nvmCryptResult.cryptKeys {
                let decryptedData = try nvmCryptResult.data.open(using: try cryptKeys.getSymmetricKey())
                return try self.nvmDecode(type, data: decryptedData)
            } else if let symmetricKey = nvmCryptResult.symmetricKey {
                let decryptedData = try nvmCryptResult.data.open(using: symmetricKey)
                return try self.nvmDecode(type, data: decryptedData)
            } else {
                throw NVMCryptResultError.invalidKey
            }
        }
    }
}

private extension NVMCrypto {
    
    private class func nvmEncode<T : Encodable>(_ value: T) throws -> Data {
        
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base64
        return try encoder.encode(value)
    }
    
    private class func nvmDecode<T : Decodable>(_ type: T.Type, data: Data) throws -> T {
        
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base64
        return try decoder.decode(type, from: data)
    }
}

fileprivate extension Data {
    
    func seal(using cryptKeys: NVMCryptKeys) throws -> NVMCryptResult {
        
        let sealedBox = try AES.GCM.seal(self, using: try cryptKeys.getSymmetricKey())
        let sealedBoxData = sealedBox.combined!

        return NVMCryptResult(data: sealedBoxData, with: cryptKeys)
    }
    
    func seal(using key: SymmetricKey) throws -> NVMCryptResult {
        
        let sealedBox = try AES.GCM.seal(self, using: key)
        let sealedBoxData = sealedBox.combined!

        return NVMCryptResult(data: sealedBoxData, with: key)
    }
    
    
    func open(using cryptKeys: NVMCryptKeys) throws -> Data {
        
        let sealedBox = try AES.GCM.SealedBox(combined: self)
        
        return try AES.GCM.open(sealedBox, using: try cryptKeys.getSymmetricKey())
    }
    
    func open(using key: SymmetricKey) throws -> Data {
        
        let sealedBox = try AES.GCM.SealedBox(combined: self)
        
        return try AES.GCM.open(sealedBox, using: key)
    }
}
