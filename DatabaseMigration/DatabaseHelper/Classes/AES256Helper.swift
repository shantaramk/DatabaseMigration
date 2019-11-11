//
//  AES256Helper.swift
//

import UIKit
import CryptoSwift

class AES256Helper: NSObject {
    
    public class func encrypt(key: String, plainText: String) -> [UInt8] {
        
        do {
            let ivector = randomAlphaNumericString(length: 16)
            let aes = try AES(key: key, iv: ivector)
            let ciphertext = try aes.encrypt(Array(plainText.utf8))
            let ivectorInUInt = Array(ivector.utf8)
            let finalArray = ivectorInUInt + ciphertext
            return finalArray
        } catch { }
        
        return Array("".utf8)
    }
    
    public class func decrypt(key: String, cipherText: [UInt8]) -> String {
        
        do {
            
            let first16 = Array(cipherText.prefix(16))
            let actualCipherText = cipherText[16...cipherText.count-1]
            let ivector = String.init(bytes: first16, encoding: .utf8)
            let aes = try AES(key: key, iv: ivector!)
            let plainText = try aes.decrypt(actualCipherText)
            let string = String.init(bytes: plainText, encoding: .utf8)
            return string!
        } catch { }
        
        return ""
    }
    
    public class func randomAlphaNumericString(length: Int) -> String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        return randomString
    }
}
