//
//  AbstractRepository.swift
//  TruckPulse
//
//  Created by Shantaram Kokate on 2/23/18.
//  Copyright © 2018 mobisoft. All rights reserved.
//

import FMDB
//import DatabaseHelper

var staticDatabase: FMDatabase! = nil

public class AbstractRepository: NSObject {

    var database: FMDatabase!
    var databaseQueue: FMDatabaseQueue!
    
    override init() {
        
        super.init()
        
        if staticDatabase == nil {
            staticDatabase = DATABASEHELPER.fmDatabase
            staticDatabase.open()
            let secretKey = DATABASEHELPER.getSecretKeyFromKeyChain()
            staticDatabase.setKey(secretKey)
        }
        
        self.database = staticDatabase
    }
    
    func truncateTable(_ table: String) -> Bool {
        let query = "DELETE FROM \(table)"
        let result = database.executeUpdate(query, withArgumentsIn: [])
        if result != true {
            print("DBResult :--- " + database.lastErrorMessage())
        }
        return result
     }
        
}
