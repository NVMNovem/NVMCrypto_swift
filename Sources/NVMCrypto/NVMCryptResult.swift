//
//  NVMCryptResult.swift
//  
//
//  Created by Damian Van de Kauter on 24/05/2023.
//

import Foundation

public struct NVMCryptResult {
    
    public let data: Data
    public let cryptKeys: NVMCryptKeys
    
    internal let encoding: String.Encoding?
    
    public init(data: Data, with cryptKeys: NVMCryptKeys,
                encoding: String.Encoding?) {
        self.data = data
        self.cryptKeys = cryptKeys
        
        self.encoding = encoding
    }
}

public extension NVMCryptResult {
    
    var stringEncoding: String.Encoding {
        return self.encoding ?? .utf8
    }
}
