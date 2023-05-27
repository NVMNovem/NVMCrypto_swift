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
    
    internal let encoding: String.Encoding?
    
    public init(data: Data, with cryptKeys: NVMCryptKeys,
                encoding: String.Encoding?) {
        self.data = data
        
        self.cryptKeys = cryptKeys
        self.symmetricKey = nil
        
        self.encoding = encoding
    }
    
    public init(data: Data, with symmetricKey: SymmetricKey,
                encoding: String.Encoding?) {
        self.data = data
        
        self.cryptKeys = nil
        self.symmetricKey = symmetricKey
        
        self.encoding = encoding
    }
}

public extension NVMCryptResult {
    
    var stringEncoding: String.Encoding {
        return self.encoding ?? .utf8
    }
}
