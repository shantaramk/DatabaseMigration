//
//  CategoriesRepository.swift
//  DatabaseMigration
//
//  Created by Shantaram Kokate on 10/4/18.
//  Copyright © 2018 Shantaram Kokate. All rights reserved.
//

import Foundation
import FMDB
/*
class CategoriesRepository: AbstractRepository {
   
    static let shared = CategoriesRepository()

    // MARK: Save Data
    
    func saveCategoryInDB(category: CategoriesList) {
        if checkIfCategoryPresent(category) {
            insertCategoryInDB(category)
        } else {
            updateCategoryInDB(category)
        }
    }
    
    func insertCategoryInDB(_ category: CategoriesList) {
        let query = "INSERT INTO categories (id,created_at,updated_at,created_by,updated_by,tenant_id,order_index,service_area_id,image_name,code,activated,category,language,description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        
        let categoryId = category.id ?? ""
        let createdAt = category.createdAt ?? 0
        let updatedAt = category.updatedAt ?? 0
        let createdBy = category.createdBy ?? 0
        let updatedBy = category.updatedBy ?? 0
        let tenantId = category.tenantID ?? ""
        let orderIndex = category.orderIndex ?? 0
        let serviceAreaId = category.serviceAreaID ?? ""
        let imageName = (category.imageName != nil) ? category.imageName?.rawValue : CategoryName.unknown.rawValue
        let code = category.code ?? ""
        let activated = category.activated ?? false
        let name = category.name ?? ""
        let language =  ""
        let description = category.description
        
        let result = database.executeUpdate(query, withArgumentsIn: [categoryId,
                                                                     createdAt,
                                                                     updatedAt,
                                                                     createdBy,
                                                                     updatedBy,
                                                                     tenantId,
                                                                     orderIndex,
                                                                     serviceAreaId,
                                                                     imageName ?? "",
                                                                     code,
                                                                     activated,
                                                                     name,
                                                                     language,
                                                                     description ?? ""])
        if result != true {
            print("Errror :--- " + database.lastErrorMessage())
        }
    }
    
    func checkIfCategoryPresent(_ category: CategoriesList) -> Bool {
        let query = "SELECT * from categories WHERE id = ?"
        let result = database.executeUpdate(query, withArgumentsIn: [category.id ?? ""])
        if result != true {
            print("DBResult :--- " + database.lastErrorMessage())
        }
        return result
    }
    
    // MARK: Update Data
    
    func updateCategoryInDB(_ category: CategoriesList) {

        let query = "UPDATE categories SET created_at = ?, updatedA_at = ?, created_by = ?, updated_by = ?, tenant_id = ?, order_index = ?, service_area_id = ?, image_name = ?, code = ?, activated = ?, category = ?, language =?, description = ? WHERE id = ?"
        
        let categoryId = category.id ?? ""
        let createdAt = category.createdAt ?? 0
        let updatedAt = category.updatedAt ?? 0
        let createdBy = category.createdBy ?? 0
        let updatedBy = category.updatedBy ?? 0
        let tenantId = category.tenantID ?? ""
        let orderIndex = category.orderIndex ?? 0
        let serviceAreaId = category.serviceAreaID ?? ""
        let imageName = (category.imageName != nil) ? category.imageName?.rawValue : CategoryName.unknown.rawValue
        let code = category.code ?? ""
        let activated = category.activated ?? false
        let name = category.name ?? ""
        let language = ""
        let description = category.description
        
        let result = database.executeUpdate(query, withArgumentsIn: [createdAt,
                                                                     updatedAt,
                                                                     createdBy,
                                                                     updatedBy,
                                                                     tenantId,
                                                                     orderIndex,
                                                                     serviceAreaId,
                                                                     imageName ?? "",
                                                                     code,
                                                                     activated,
                                                                     name,
                                                                     language,
                                                                     description ?? "",
                                                                     categoryId])
        
        if result != true {
            print("Errror :--- " + database.lastErrorMessage())
        }
    }
    
    func updateCategorySelectedStatus(_ status: Bool, forPrivacyId: String) {
        let query = "UPDATE categories SET optional = ? WHERE id= ?"
        
        let result = database.executeUpdate(query, withArgumentsIn: [status,
                                                                     forPrivacyId])
        if result != true {
            print("Errror :--- " + database.lastErrorMessage())
        }
    }
    
    // MARK: Get Data
    
    func getCategoriesFromDB() -> [CategoriesList] {
        var category = [CategoriesList]()
        
        let query = "SELECT * from categories WHERE activated = 1"
        let resultSet: FMResultSet? = database.executeQuery(query as String, withArgumentsIn: [""])
        if resultSet != nil {
            while (resultSet?.next())! {
                category.append(self.getCategoryFromResultSet(resultSet!))
            }
            resultSet?.close()
        }
        return category
    }
    
    // MARK: - Fetch ResultSet Records into Model
    
    func getCategoryFromResultSet (_ resultSet: FMResultSet) -> CategoriesList {
        var category = CategoriesList()
        category.id = resultSet.string(forColumn: "id")!
        category.createdAt = resultSet.double(forColumn: "created_at")
        category.updatedAt = resultSet.double(forColumn: "updated_at")
        category.createdBy = resultSet.double(forColumn: "created_by")
        category.updatedBy = resultSet.double(forColumn: "updated_by")
        category.tenantID = resultSet.string(forColumn: "tenant_id")
        category.orderIndex = resultSet.double(forColumn: "order_index")
        category.serviceAreaID = resultSet.string(forColumn: "service_area_id")!
        category.imageName = CategoryName(rawValue: resultSet.string(forColumn: "image_name")!)
        category.code = resultSet.string(forColumn: "code")
        category.activated = resultSet.bool(forColumn: "activated")
        category.name = resultSet.string(forColumn: "category")
        category.language = resultSet.string(forColumn: "language")!
        category.description = resultSet.string(forColumn: "description")
        return category
    }
    
    func getInfoFromResultSet (_ resultSet: FMResultSet) -> String {
        let label = resultSet.string(forColumn: "label")
        return label!
    }
}
*/
