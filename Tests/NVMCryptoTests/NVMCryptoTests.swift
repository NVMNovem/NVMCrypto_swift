import XCTest
@testable import NVMCrypto

final class NVMCryptoTests: XCTestCase {
    
    func testTextDecrypting() throws {
        let testString: String = "This is a test string to be encrypted with NVMCrypto."
        
        let nvmCryptResult = try NVMCrypto.encrypt(testString)
        let decryptedString = try NVMCrypto.decrypt(String.self, data: nvmCryptResult.data, with: nvmCryptResult.cryptKeys!)
        
        XCTAssertEqual(testString, decryptedString, "decryptedString: \(decryptedString)")
    }
    
    func testNumberDecrypting() throws {
        let testNumber: Int = 123456789
        
        let nvmCryptResult = try NVMCrypto.encrypt(testNumber)
        let decryptedNumber = try NVMCrypto.decrypt(Int.self, data: nvmCryptResult.data, with: nvmCryptResult.cryptKeys!)
        
        XCTAssertEqual(testNumber, decryptedNumber, "decryptedNumber: \(decryptedNumber)")
    }
    
    func testBoolDecrypting() throws {
        let testBool: Bool = true
        
        let nvmCryptResult = try NVMCrypto.encrypt(testBool)
        let decryptedBool = try NVMCrypto.decrypt(Bool.self, data: nvmCryptResult.data, with: nvmCryptResult.cryptKeys!)
        
        XCTAssertEqual(testBool, decryptedBool, "decryptedBool: \(decryptedBool)")
    }
    
    func testArrayDecrypting() throws {
        let testArray: [String] = ["This", "is", "a", "test", "array", "to", "be", "encrypted", "with", "NVMCrypto"]
        
        let nvmCryptResult = try NVMCrypto.encrypt(testArray)
        let decryptedArray = try NVMCrypto.decrypt([String].self, data: nvmCryptResult.data, with: nvmCryptResult.cryptKeys!)
        
        XCTAssertEqual(testArray, decryptedArray, "decryptedArray: \(decryptedArray)")
    }
    
    func testDictionaryDecrypting() throws {
        let testDictionary: [String : Int] = ["This" : 1,
                                              "is" : 2,
                                              "a" : 3,
                                              "test" : 4,
                                              "array" : 5,
                                              "to" : 6,
                                              "be" : 7,
                                              "encrypted" : 8,
                                              "with" : 9,
                                              "NVMCrypto" : 10]
        
        let nvmCryptResult = try NVMCrypto.encrypt(testDictionary)
        let decryptedDictionary = try NVMCrypto.decrypt([String : Int].self, data: nvmCryptResult.data, with: nvmCryptResult.cryptKeys!)
        
        XCTAssertEqual(testDictionary, decryptedDictionary, "decryptedDictionary: \(decryptedDictionary)")
    }
    
    
    
    func testNVMDecrypting() throws {
        let testString: String = "This is a test string to be encrypted with NVMCrypto."
        
        let nvmCryptResult = try NVMCrypto.encrypt(testString)
        let decryptedString = try NVMCrypto.decrypt(String.self, from: nvmCryptResult)
        
        XCTAssertEqual(testString, decryptedString, "decryptedString: \(decryptedString)")
    }
    
    
    
    func testFailDecrypting() throws {
        let testString: String = "This is a test string to be encrypted with NVMCrypto."
        
        let nvmCryptResult = try NVMCrypto.encrypt(testString)
        XCTAssertNil(try? NVMCrypto.decrypt(String.self, data: nvmCryptResult.data, with: NVMCryptKeys()))
    }
    
    
    
    func testNVMCryptKeysStrings() throws {
        let testString: String = "This is a test string to be encrypted with NVMCrypto."
        
        let nvmCryptResult = try NVMCrypto.encrypt(testString)
        let cryptKeys = NVMCryptKeys(privateKey: nvmCryptResult.cryptKeys!.privateKeyString,
                                     publicKey: nvmCryptResult.cryptKeys!.publicKeyString,
                                     salt: nvmCryptResult.cryptKeys!.saltString)
        XCTAssertNotNil(cryptKeys)
        if let cryptKeys {
            let decryptedString = try NVMCrypto.decrypt(String.self, data: nvmCryptResult.data, with: cryptKeys)
            
            XCTAssertEqual(testString, decryptedString, "decryptedString: \(decryptedString)")
        }
    }
}
