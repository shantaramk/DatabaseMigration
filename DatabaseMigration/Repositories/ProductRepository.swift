//
//  ServicesRepository.swift
//  DatabaseMigration
//
//  Created by Shantaram Kokate on 10/4/18.
//  Copyright © 2018 Shantaram Kokate. All rights reserved.
//

import Foundation
import FMDB

class ServicesRepository: AbstractRepository {
    
    static let shared = ServicesRepository()
    
    // MARK: Save Data
    func saveServicesInDB(services: Services) {
        if checkIfServicePresent(services) {
            insertServicesInDB(services)
        } else {
            updateServicesInDB(services)
        }
    }
    
    func insertServicesInDB(_ services: Services) {
        let query = "INSERT INTO services (id,created_at,updated_at,created_by,updated_by,tenant_id,category_id,order_index,code,base_fare,popular,activated,document_required,service,language,description,image_name,search_tags) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        
        let serviceId = services.id ?? ""
        let createdAt = services.createdAt ?? 0
        let updatedAt = services.updatedAt ?? 0
        let createdBy = services.createdBy ?? 0
        let updatedBy = services.updatedBy ?? 0
        let tenantId = services.tenantId ?? ""
        let categoryId = services.categoryId ?? ""
        let orderIndex = services.orderIndex ?? 0
        let code = services.code ?? ""
        let baseFare = services.baseFare ?? 0
        let popular = services.popular ?? false
        let activated = services.activated ?? false
        let documentRequired = services.documentRequired ?? false
        let service = services.service ?? ""
        let language = services.language ?? ""
        let description = services.description ?? ""
        let imageName = services.imageName ?? ""
        let tag = services.searchTags ?? ""

        let result = database.executeUpdate(query, withArgumentsIn: [serviceId,
                                                                     createdAt,
                                                                     updatedAt,
                                                                     createdBy,
                                                                     updatedBy,
                                                                     tenantId,
                                                                     categoryId,
                                                                     orderIndex,
                                                                     code,
                                                                     baseFare,
                                                                     popular,
                                                                     activated,
                                                                     documentRequired,
                                                                     service,
                                                                     language,
                                                                     description,
                                                                     imageName,
                                                                     tag])
        if result != true {
            print("Errror :--- " + database.lastErrorMessage())
        }
    }
    
    func checkIfServicePresent(_ services: Services) -> Bool {
        let query = "SELECT * from services WHERE id = ?"
        let result = database.executeUpdate(query, withArgumentsIn: [services.id ?? ""])
        if result != true {
            print("DBResult :--- " + database.lastErrorMessage())
        }
        return result
    }

    // MARK: Update Data
    
    func updateServicesInDB(_ services: Services) {
        
        let query = "UPDATE services SET created_at = ?, updated_at = ?, created_by = ?, updated_by = ?, tenant_id = ?, category_id = ?, order_index = ?, code = ?, base_fare = ?, popular = ?, activated = ?, document_required = ?, service = ?, language = ?, description = ?, image_name = ?, search_tags = ? WHERE id = ?"
        
        let serviceId = services.id ?? ""
        let createdAt = services.createdAt ?? 0
        let updatedAt = services.updatedAt ?? 0
        let createdBy = services.createdBy ?? 0
        let updatedBy = services.updatedBy ?? 0
        let tenantId = services.tenantId ?? ""
        let categoryId = services.categoryId ?? ""
        let orderIndex = services.orderIndex ?? 0
        let code = services.code ?? ""
        let baseFare = services.baseFare ?? 0
        let popular = services.popular ?? false
        let activated = services.activated ?? false
        let documentRequired = services.documentRequired ?? false
        let service = services.service ?? ""
        let language = services.language ?? ""
        let description = services.description ?? ""
        let imageName = services.imageName ?? ""
        let tag = services.searchTags ?? ""

        let result = database.executeUpdate(query, withArgumentsIn: [createdAt,
                                                                     updatedAt,
                                                                     createdBy,
                                                                     updatedBy,
                                                                     tenantId,
                                                                     categoryId,
                                                                     orderIndex,
                                                                     code,
                                                                     baseFare,
                                                                     popular,
                                                                     activated,
                                                                     documentRequired,
                                                                     service,
                                                                     language,
                                                                     description,
                                                                     imageName,
                                                                     tag,
                                                                     serviceId])
        
        if result != true {
            print("Errror :--- " + database.lastErrorMessage())
        }
    }
    
    func updateservicesSelectedStatus(_ status: Bool, forPrivacyId: String) {
        
        let query = "UPDATE services SET optional = ? WHERE id= ?"
        let result = database.executeUpdate(query, withArgumentsIn: [status,
                                                                     forPrivacyId])
        if result != true {
            print("Errror :--- " + database.lastErrorMessage())
        }
    }
    
    // MARK: Get Data
    
    func getServicesInDB() -> [Services] {
        
        var services = [Services]()
        let query = "SELECT * from services WHERE activated = 1"
        let resultSet: FMResultSet? = database.executeQuery(query as String, withArgumentsIn: [""])
        if resultSet != nil {
            while (resultSet?.next())! {
                services.append(self.getServicesFromResultSet(resultSet!))
            }
            resultSet?.close()
        }
        return services
    }
    
    func getServices(forCategory categoryId: String) -> [Services] {
        
        var services = [Services]()
        let query = "SELECT * from services WHERE activated = 1 AND category_id = ?"
        let resultSet: FMResultSet? = database.executeQuery(query as String, withArgumentsIn: [categoryId])
        if resultSet != nil {
            while (resultSet?.next())! {
                services.append(self.getServicesFromResultSet(resultSet!))
            }
            resultSet?.close()
        }
        return services
    }
    
    func getServices(serviceId: String, forCategoryId: String) -> Services? {
        
        let query = "SELECT * from services WHERE activated = 1 AND category_id = ? AND id = ?"
        let resultSet: FMResultSet? = database.executeQuery(query as String, withArgumentsIn: [forCategoryId, serviceId])
        if resultSet != nil {
            while (resultSet?.next())! {
                return self.getServicesFromResultSet(resultSet!)
            }
            resultSet?.close()
        }
         return nil
    }
    
    func getServices(forSearchText searchText: String, categoryId: String) -> [Services] {
        
        var services = [Services]()
        let textoLike: String = "%\(searchText)%"
        let query = "SELECT * from services WHERE activated = 1 AND category_id = ? AND (replace(service, ',', ' ') LIKE ? OR replace(search_tags, ',', ' ') LIKE ?)"
        let resultSet: FMResultSet? = database.executeQuery(query as String, withArgumentsIn: [categoryId, textoLike, textoLike])
        if resultSet != nil {
            while (resultSet?.next())! {
                services.append(self.getServicesFromResultSet(resultSet!))
            }
            resultSet?.close()
        }
        return services
    }
    
    func getServices(forSearchText searchText: String) -> [Services] {
        
        var services = [Services]()
        let textoLike: String = "%\(searchText)%"
       // let query = "SELECT * from services WHERE activated = 1 AND service LIKE ? COLLATE Latin1_General_CI_AI OR search_tags LIKE ?"
       let query = "SELECT * from services WHERE activated = 1 AND (replace(service, ',', ' ') LIKE ? OR replace(search_tags, ',', ' ') LIKE ?)"
        let resultSet: FMResultSet? = database.executeQuery(query as String, withArgumentsIn: [textoLike, textoLike])
        if resultSet != nil {
            while (resultSet?.next())! {
                services.append(self.getServicesFromResultSet(resultSet!))
            }
            resultSet?.close()
        }
        return services
    }
    
    // MARK: - Fetch ResultSet Records into Model
    
    func getServicesFromResultSet (_ resultSet: FMResultSet) -> Services {
        
        var services = Services()
        services.id = resultSet.string(forColumn: "id")!
        services.createdAt = resultSet.double(forColumn: "created_at")
        services.updatedAt = resultSet.double(forColumn: "updated_at")
        services.createdBy = resultSet.double(forColumn: "created_by")
        services.updatedBy = resultSet.double(forColumn: "updated_by")
        services.tenantId = resultSet.string(forColumn: "tenant_id")
        services.categoryId = resultSet.string(forColumn: "category_id")
        services.code = resultSet.string(forColumn: "code")!
        services.baseFare = resultSet.double(forColumn: "base_fare")
        services.popular = resultSet.bool(forColumn: "popular")
        services.activated = resultSet.bool(forColumn: "activated")
        services.documentRequired = resultSet.bool(forColumn: "document_required")
        services.service = resultSet.string(forColumn: "service")
        services.language = resultSet.string(forColumn: "language")!
        services.description = resultSet.string(forColumn: "description")
        services.imageName = resultSet.string(forColumn: "image_name") ?? ""
        services.searchTags = resultSet.string(forColumn: "search_tags") ?? ""

        return services
    }
    
    func getInfoFromResultSet (_ resultSet: FMResultSet) -> String {
        
        let label = resultSet.string(forColumn: "label")
        return label!
    }
}
