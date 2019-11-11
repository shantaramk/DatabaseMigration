//
//  ProductRepository.swift
//  DatabaseMigration
//
//  Created by Shantaram Kokate on 10/4/18.
//  Copyright © 2018 Shantaram Kokate. All rights reserved.
//

import Foundation
import FMDB

class ProductRepository: AbstractRepository {
    
    static let shared = ProductRepository()
    
    // MARK: Save Data
    func saveServicesInDB(product: ProductInfo) {
        if checkIfServicePresent(product) {
            insertServicesInDB(product)
        } else {
            updateServicesInDB(product)
        }
    }
    
    func insertServicesInDB(_ product: ProductInfo) {
        let query = "INSERT INTO product (name,product_id,description) VALUES (?, ?, ?)"
        
        let productID = product.id
        let name = product.name
        let descriptions = product.descriptions


        let result = database.executeUpdate(query, withArgumentsIn: [productID,
                                                                     name,
                                                                     descriptions,
                                                                      ])
        if result != true {
            print("Errror :--- " + database.lastErrorMessage())
        }
    }
    
    func checkIfServicePresent(_ product: ProductInfo) -> Bool {
        let query = "SELECT * from product WHERE product_id = ?"
        let result = database.executeUpdate(query, withArgumentsIn: [product.id])
        if result != true {
            print("DBResult :--- " + database.lastErrorMessage())
        }
        return result
    }

    // MARK: Update Data
    
    func updateServicesInDB(_ product: ProductInfo) {
        
        let query = "UPDATE product SET name = ?, product_id = ?, description = ? WHERE id = ?"
        
    
        let productID = product.id
        let name = product.name
        let descriptions = product.descriptions

        let result = database.executeUpdate(query, withArgumentsIn: [productID,
                                                                     name,
                                                                     descriptions,
                                                                     productID
                                                                     ])
        
        if result != true {
            print("Errror :--- " + database.lastErrorMessage())
        }
    }
    
    func updateservicesSelectedStatus(_ status: Bool, forPrivacyId: String) {
        
        let query = "UPDATE product SET optional = ? WHERE id= ?"
        let result = database.executeUpdate(query, withArgumentsIn: [status,
                                                                     forPrivacyId])
        if result != true {
            print("Errror :--- " + database.lastErrorMessage())
        }
    }
    
    // MARK: Get Data
    
    func getServicesInDB() -> [ProductInfo] {
        
        var product = [ProductInfo]()
        let query = "SELECT * from product"
        let resultSet: FMResultSet? = database.executeQuery(query as String, withArgumentsIn: [""])
        if resultSet != nil {
            while (resultSet?.next())! {
                product.append(self.getProductFromResultSet(resultSet!))
            }
            resultSet?.close()
        }
        return product
    }
 
    func getServices(serviceId: String, forCategoryId: String) -> ProductInfo? {
        
        let query = "SELECT * from services WHERE activated = 1 AND category_id = ? AND id = ?"
        let resultSet: FMResultSet? = database.executeQuery(query as String, withArgumentsIn: [forCategoryId, serviceId])
        if resultSet != nil {
            while (resultSet?.next())! {
                return self.getProductFromResultSet(resultSet!)
            }
            resultSet?.close()
        }
         return nil
    }
    
    func getServices(forSearchText searchText: String, categoryId: String) -> [ProductInfo] {
        
        var services = [ProductInfo]()
        let textoLike: String = "%\(searchText)%"
        let query = "SELECT * from services WHERE activated = 1 AND category_id = ? AND (replace(service, ',', ' ') LIKE ? OR replace(search_tags, ',', ' ') LIKE ?)"
        let resultSet: FMResultSet? = database.executeQuery(query as String, withArgumentsIn: [categoryId, textoLike, textoLike])
        if resultSet != nil {
            while (resultSet?.next())! {
                services.append(self.getProductFromResultSet(resultSet!))
            }
            resultSet?.close()
        }
        return services
    }
    
    func getProduct(forSearchText searchText: String) -> [ProductInfo] {
        
        var services = [ProductInfo]()
        let textoLike: String = "%\(searchText)%"
       // let query = "SELECT * from services WHERE activated = 1 AND service LIKE ? COLLATE Latin1_General_CI_AI OR search_tags LIKE ?"
       let query = "SELECT * from services WHERE activated = 1 AND (replace(service, ',', ' ') LIKE ? OR replace(search_tags, ',', ' ') LIKE ?)"
        let resultSet: FMResultSet? = database.executeQuery(query as String, withArgumentsIn: [textoLike, textoLike])
        if resultSet != nil {
            while (resultSet?.next())! {
                services.append(self.getProductFromResultSet(resultSet!))
            }
            resultSet?.close()
        }
        return services
    }
    
    // MARK: - Fetch ResultSet Records into Model
    
    func getProductFromResultSet (_ resultSet: FMResultSet) -> ProductInfo {
        
        let product = ProductInfo(name: resultSet.string(forColumn: "name")!,
                                  id:  resultSet.string(forColumn: "product_id")!,
                    description: resultSet.string(forColumn: "description")!)
 
        return product
    }
}
