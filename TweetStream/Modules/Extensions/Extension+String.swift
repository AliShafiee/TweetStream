//
//  Extension+String.swift
//  TweetStream
//
//  Created by Ali Shafiee on 3/2/1401 AP.
//

import Foundation
import CommonCrypto

extension String {
    
    func aesDecrypt(options: Int = kCCOptionPKCS7Padding) -> String? {
        let key = "D5934C55CE9A44A3"
        let iv = "3636B91F9B11113C"
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
            let cryptData    = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {
            
            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options: CCOptions   = UInt32(options)
            
            var numBytesEncrypted: size_t = 0
            
            let cryptStatus = CCCrypt(operation,
                                      algoritm,
                                      options,
                                      (keyData as NSData).bytes, keyLength,
                                      iv,
                                      data.bytes, data.length,
                                      cryptData.mutableBytes, cryptData.length,
                                      &numBytesEncrypted)
            
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let unencryptedMessage = String(data: cryptData as Data, encoding: String.Encoding.utf8)
                return unencryptedMessage
            } else {
                return nil
            }
        }
        return nil
    }
    
}
