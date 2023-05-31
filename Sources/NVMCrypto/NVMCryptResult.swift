//
//  NVMCryptResult.swift
//  
//
//  Created by Damian Van de Kauter on 24/05/2023.
//

import Foundation
import CryptoKit

public struct NVMCryptResult {
    
    public let data: Data
    
    public let cryptKeys: NVMCryptKeys?
    public let symmetricKey: SymmetricKey?
    
    public init(data: Data, with cryptKeys: NVMCryptKeys) {
        self.data = data
        
        self.cryptKeys = cryptKeys
        self.symmetricKey = nil
    }
    
    public init(data: Data, with symmetricKey: SymmetricKey) {
        self.data = data
        
        self.cryptKeys = nil
        self.symmetricKey = symmetricKey
    }
}

public extension NVMCryptResult {
    
    var dataString: String {
        return self.data.base64EncodedString()
    }
}
