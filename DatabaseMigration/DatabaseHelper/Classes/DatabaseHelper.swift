//
//  DatabaseHelper.swift
//
//

import UIKit
import SQLite3
import FMDB

public let DATABASEHELPER = DatabaseHelper.sharedDatabaseHelper

private let _sharedDatabaseHelper = DatabaseHelper()

public class DatabaseHelper: NSObject {
    
    public var fmDatabase: FMDatabase!
    var dbPath: String!
    var database: OpaquePointer!
    var databaseName: String!
    var encryptedDatabaseName: String!
    var hardCodedLongKey = "BEn8NA8xSHFDE2z1Ziaivd3FKV5UKL5t"
    
    class var sharedDatabaseHelper: DatabaseHelper {
        return _sharedDatabaseHelper
    }
    
    public func initializeDatabase(_ name: String) {
        
        databaseName = name
        encryptedDatabaseName = "encrypted" + name
        
        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        dbPath = documentsPath + "/" + encryptedDatabaseName
        
        if !fileManager.fileExists(atPath: dbPath) {
            
            do {
                let fileURL = try FileManager.default.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: false).appendingPathComponent(databaseName)
                
                var database = self.database
                if sqlite3_open(fileURL.path, &database) != SQLITE_OK {
                    print("Failed to create database")
                }
                
                // Encrypt Database
                encryptDatabaseFile()
                
            } catch let error {
                print(error)
            }
        } else {
            dbPath = documentsPath + "/" + encryptedDatabaseName
            fmDatabase = FMDatabase.init(path: dbPath)
        }
    }
    
    private func encryptDatabaseFile() {
        
        var encryptedDatabase: OpaquePointer?
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let ecDB = documentsPath + "/" + encryptedDatabaseName
        
        let secretKey = self.createKeyEncryptAndSaveToKeychain()
        
        let result = String.init(cString: "ATTACH DATABASE '\(ecDB)' AS encrypted KEY '\(secretKey)';", encoding: .utf8)
        if  sqlite3_open(dbPath, &encryptedDatabase) == SQLITE_OK {
            // Attach empty encrypted database to unencrypted database
            sqlite3_exec(encryptedDatabase, result!, nil, nil, nil)
            // export database
            sqlite3_exec(encryptedDatabase, "SELECT sqlcipher_export('encrypted');", nil, nil, nil)
            // Detach encrypted database
            sqlite3_exec(encryptedDatabase, "DETACH DATABASE encrypted;", nil, nil, nil)
            sqlite3_close(encryptedDatabase)
        } else {
            print("failed to open database..")
            sqlite3_close(encryptedDatabase)
            sqlite3_errmsg(encryptedDatabase)
        }
        
        dbPath = ecDB
        fmDatabase = FMDatabase.init(path: dbPath)
        removeNonEncryptedDatabase()
    }
    
    func removeNonEncryptedDatabase() {
        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        dbPath = documentsPath + "/" + databaseName
        do {
            try fileManager.removeItem(atPath: dbPath)
        } catch let error {
            print(error)
        }
    }
    
    func createKeyEncryptAndSaveToKeychain() -> String {
        
        let sqlKey = AES256Helper.randomAlphaNumericString(length: 32)
        let sqlSecretKey = AES256Helper.randomAlphaNumericString(length: 16)
        let encryptedSecretKey = AES256Helper.encrypt(key: sqlKey, plainText: sqlSecretKey)
        let encryptedSecretKeyData = NSKeyedArchiver.archivedData(withRootObject: encryptedSecretKey)
        KeychainHelper.saveDataToKeyChain(value: encryptedSecretKeyData, forKey: "sqlSecretKey")
        
        let encryptedSqlKey = AES256Helper.encrypt(key: self.hardCodedLongKey, plainText: sqlKey)
        let encryptedSqlKeyData = NSKeyedArchiver.archivedData(withRootObject: encryptedSqlKey)
        KeychainHelper.saveDataToKeyChain(value: encryptedSqlKeyData, forKey: "sqlKey")
        
        return sqlSecretKey
    }
    
    public func getSecretKeyFromKeyChain() -> String {
        
        let encryptedSqlKeyData = KeychainHelper.getDataValueFromKeyChain(forkey: "sqlKey")
        guard let encryptedSqlKey = NSKeyedUnarchiver.unarchiveObject(with: encryptedSqlKeyData) as? [UInt8] else {fatalError("unable to convert data to UInt8")}
        let sqlKey = AES256Helper.decrypt(key: hardCodedLongKey, cipherText: encryptedSqlKey)
        
        let encryptedSqlSecretKeyData = KeychainHelper.getDataValueFromKeyChain(forkey: "sqlSecretKey")
        guard let encryptedSqlSecretKey = NSKeyedUnarchiver.unarchiveObject(with: encryptedSqlSecretKeyData) as? [UInt8] else {fatalError("unable to convert data to UInt8")}
        let secretKey = AES256Helper.decrypt(key: sqlKey, cipherText: encryptedSqlSecretKey)
        return secretKey
    }
    
    func version() -> Int {
        
        return Int(fmDatabase.userVersion)
    }
    
    public func migrateToVersion(version: Int) {
        
        fmDatabase.open()
        
        let secretKey = self.getSecretKeyFromKeyChain()
        fmDatabase.setKey(secretKey)
        let currentVersion = self.version()
        if currentVersion == version {
            fmDatabase.close()
            return
        }
        
        var success: Bool = false
        var updatedVersion = currentVersion + 1
        while updatedVersion <= version {
            success = self.applyMigration(version: updatedVersion)
            if success == false {
                break
            }
            fmDatabase.userVersion = UInt32(updatedVersion)
            updatedVersion += 1
        }
        fmDatabase.close()
        
        if success == true {
            print("Scuccessfully migrated to version \(version)")
        } else {
            print("There were error during migration to version \(updatedVersion)")
        }
    }
    
    public func applyMigration(version: Int) -> Bool {
        
        let migrationFile = "/migration-\(version).sql"
        let migrationFileFullPath = Bundle.main.resourcePath! + migrationFile
        
        if  FileManager.default.fileExists(atPath: migrationFileFullPath) == false {
            return false
        }
        do {
            let migrationSqlStatements = try String.init(contentsOfFile: migrationFileFullPath, encoding: .utf8)
            let statements: [String]? = migrationSqlStatements.components(separatedBy: ";")
            for statement in statements! {
                let cleanedStatement = statement.trimmingCharacters(in: .whitespacesAndNewlines)
                if cleanedStatement.isEmpty == false {
                    do {
                        try fmDatabase.executeUpdate(cleanedStatement, values: nil)
                    } catch let error as NSError {
                        print("Error in executing the migration statements in file \(migrationFile) & error = \(error)")
                    }
                }
            }
        } catch let error as NSError {
            print("Error in reading a file \(migrationFile) & error = \(error)")
        }
        
        return true
    }
}
