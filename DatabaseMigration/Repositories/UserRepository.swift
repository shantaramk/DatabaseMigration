//
//  UserRepository.swift
//  DatabaseMigration
//
//  Created by Shantaram Kokate on 9/21/18.
//  Copyright © 2018 Shantaram Kokate. All rights reserved.
//

import Foundation

class UserRepository: AbstractRepository {
    
    static let shared = UserRepository()

    // MARK: Save Data
    func saveAddressInDB(address: Address) {
        if checkIfAddressPresent(address) {
            insertAddressInDB(address)
        } else {
            updateAddressInDB(address)
        }
        
    }
    
    func insertAddressInDB(_ address: Address) {
         let query = "INSERT INTO Addresses (Id,UserId,AddressLine1,AddressLine2,nickName,Landmark,CountryCode,StateCode,CityId,Zipcode,PoBox,FlatNumber,StreetNumber,BillingAddress,AddressLocation) VALUES (?, ?, ?, ?, ?, ? , ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        let addressId = address.id ?? ""
        let userId = address.userId ?? ""
        let address1 = address.addressLine1 ?? ""
        let address2 = address.addressLine1 ?? ""
        let addressNickname = address.addressNickname ?? ""
        let landmark = address.landmark ?? ""
        let countryCode = address.countryCode ?? ""
        let stateCode = address.stateCode ?? ""
        let cityId = address.cityId ?? ""
        let zipCode = address.zipCode ?? ""
        let poBox = address.poBox ?? ""
        let flatNum = address.flatNum ?? ""
        let streetNum = address.streetNum ?? ""
        let billingAddress =  ""
        let location = address.addressLocation ?? ""

        let result = database.executeUpdate(query, withArgumentsIn: [addressId,
                                                                     userId,
                                                                     address1,
                                                                     address2,
                                                                     addressNickname,
                                                                     landmark,
                                                                     countryCode,
                                                                     stateCode,
                                                                     cityId,
                                                                     zipCode,
                                                                     poBox,
                                                                     flatNum,
                                                                     streetNum,
                                                                     billingAddress,
                                                                     location])
        if result != true {
            print("Errror :--- " + database.lastErrorMessage())
        }
     }
    
    func checkIfAddressPresent(_ address: Address) -> Bool {
        let query = "SELECT * from Addresses WHERE Id = ?"
        let result = database.executeUpdate(query, withArgumentsIn: [address.id ?? ""])
        if result != true {
            print("DBResult :--- " + database.lastErrorMessage())
        }
        return result
    }
    
    // MARK: Update Data
    
    func updateAddressInDB(_ address: Address) {
        let query = "UPDATE Addresses SET UserId = ?, AddressLine1 = ?, AddressLine2 = ?, nickName = ?, Landmark = ?, CountryCode = ?, StateCode = ?, CityId = ?, Zipcode = ?, PoBox = ?, FlatNumber = ?, StreetNumber = ?, BillingAddress = ?, AddressLocation = ? WHERE Id = ?"

        let addressId = address.id ?? ""
        let userId = address.userId ?? ""
        let address1 = address.addressLine1 ?? ""
        let address2 = address.addressLine2 ?? ""
        let addressNickname = address.addressNickname ?? ""
        let landmark = address.landmark ?? ""
        let countryCode = address.countryCode ?? ""
        let stateCode = address.stateCode ?? ""
        let cityId = address.cityId ?? ""
        let zipCode = address.zipCode ?? ""
        let poBox = address.poBox ?? ""
        let flatNum = address.flatNum ?? ""
        let streetNum = address.streetNum ?? ""
        let billingAddress =  ""
        let location = address.addressLocation ?? ""
        
        let result = database.executeUpdate(query, withArgumentsIn: [userId,
                                                                     address1,
                                                                     address2,
                                                                     addressNickname,
                                                                     landmark,
                                                                     countryCode,
                                                                     stateCode,
                                                                     cityId,
                                                                     zipCode,
                                                                     poBox,
                                                                     flatNum,
                                                                     streetNum,
                                                                     billingAddress,
                                                                     location,
                                                                     addressId])
        if result != true {
            print("Errror :--- " + database.lastErrorMessage())
        }
    }
    
    func removeAllDataFromDataBase() {
        removeUserId()
        removeAllTable()
        removeUserDefaults()
    
    }
    
    func removeAllTable() {
        
        let tableList = ["Addresses"]
        for table in tableList {
            let query = "DELETE FROM \(table)"
            let result = database.executeUpdate(query, withArgumentsIn: [""])
            if result != true {
                print("DBResult :--- " + database.lastErrorMessage())
            }
        }
    }
    
    func removeUserDefaults() {
        
        let query = "DELETE FROM UserDefaults WHERE key != isAppTutoiralCompleted AND key != isZipcodeFirstTime"
        let result = database.executeUpdate(query, withArgumentsIn: [""])
        if result != true {
            print("DBResult :--- " + database.lastErrorMessage())
        }
    }
    
    func removeUserId() {
        _ =   UserDefaultUtils.sharedInstance.removeValueFromDB(key: USERID)
    }
}
