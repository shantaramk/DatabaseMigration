//
//  KeychainHelper.swift
//

import UIKit
import SwiftKeychainWrapper

class KeychainHelper: NSObject {
    
    public class func saveStringToKeyChain(value: String, forKey key: String) {
        
        KeychainWrapper.standard.set(value, forKey: key)
    }
    
    public class func getStringValueFromKeyChain(forkey key: String) -> String {
        
        return KeychainWrapper.standard.string(forKey: key)!
    }
    
    public class func saveIntToKeyChain(value: Int, forKey key: String) {
        
        KeychainWrapper.standard.set(value, forKey: key)
    }
    
    public class func getIntValueFromKeyChain(forkey key: String) -> Int {
        
        return KeychainWrapper.standard.integer(forKey: key)!
    }
    
    public class func saveBoolToKeyChain(value: Bool, forKey key: String) {
        
        KeychainWrapper.standard.set(value, forKey: key)
    }
    
    public class func getBoolValueFromKeyChain(forkey key: String) -> Bool {
        
        return KeychainWrapper.standard.bool(forKey: key)!
    }
    
    public class func saveFloatToKeyChain(value: Float, forKey key: String) {
        
        KeychainWrapper.standard.set(value, forKey: key)
    }
    
    public class func getFloatValueFromKeyChain(forkey key: String) -> Float {
        
        return KeychainWrapper.standard.float(forKey: key)!
    }
    
    public class func saveDoubleToKeyChain(value: Double, forKey key: String) {
        
        KeychainWrapper.standard.set(value, forKey: key)
    }
    
    public class func getDoubleValueFromKeyChain(forkey key: String) -> Double {
        
        return KeychainWrapper.standard.double(forKey: key)!
    }
    
    public class func saveDataToKeyChain(value: Data, forKey key: String) {
        
        KeychainWrapper.standard.set(value, forKey: key)
    }
    
    public class func getDataValueFromKeyChain(forkey key: String) -> Data {
        
        return KeychainWrapper.standard.data(forKey: key)!
    }
}
