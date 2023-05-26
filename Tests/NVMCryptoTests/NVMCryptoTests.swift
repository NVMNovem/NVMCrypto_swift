import XCTest
@testable import NVMCrypto

final class NVMCryptoTests: XCTestCase {
    let testString = "This is a test string to be encrypted with NVMCrypto."
    
    func testDecrypting() throws {
        
        let nvmCryptResult = try NVMCrypto.encryptString(testString)
        let decryptedString = try NVMCrypto.decryptString(nvmCryptResult.data, with: nvmCryptResult.cryptKeys)
        
        XCTAssertEqual(testString, decryptedString, "decryptedString: \(decryptedString)")
    }
    
    func testNVMDecrypting() throws {
        
        let nvmCryptResult = try NVMCrypto.encryptString(testString)
        let decryptedString = try NVMCrypto.decryptString(nvmCryptResult)
        
        XCTAssertEqual(testString, decryptedString, "decryptedString: \(decryptedString)")
    }
    
    func testFailDecrypting() throws {
        
        let nvmCryptResult = try NVMCrypto.encryptString(testString)
        XCTAssertNil(try? NVMCrypto.decryptString(nvmCryptResult.data, with: NVMCryptKeys()))
    }
    
    
    
    func testNVMCryptKeysStrings() throws {
        
        let nvmCryptResult = try NVMCrypto.encryptString(testString)
        let cryptKeys = NVMCryptKeys(privateKey: nvmCryptResult.cryptKeys.privateKeyString,
                                     publicKey: nvmCryptResult.cryptKeys.publicKeyString,
                                     salt: nvmCryptResult.cryptKeys.saltString)
        XCTAssertNotNil(cryptKeys)
        if let cryptKeys {
            let decryptedString = try NVMCrypto.decryptString(nvmCryptResult.data, with: cryptKeys)
            
            XCTAssertEqual(testString, decryptedString, "decryptedString: \(decryptedString)")
        }
    }
}
