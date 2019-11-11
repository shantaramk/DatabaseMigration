//
//  ViewController.swift
//  DatabaseMigration
//
//  Created by Shantaram K on 21/06/19.
//  Copyright © 2019 Shantaram Kokate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var productList = [ProductInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadProduct()
        storeProductInDB()
    }
    
    private func loadProduct() {
        let iphoneX = ProductInfo(name: "Apple iPhone X (Silver, 64 GB)",
                                  id: "0",
                                  description: "Meet the iPhone X - the device that's so smart that it responds to a tap, your voice, and even a glance. Elegantly designed with a large 14.73 cm (5.8) Super Retina screen and a durable front-and-back glass, this smartphone is designed to impress. What's more, you can charge this iPhone wirelessly.")
        
        let hpLaptop = ProductInfo(name: "HP Laptop(15.6 inch)",
                                   id: "1",
                                  description: "Experience efficiency and performance like never before with this amazing 39.62-cm (15.6) laptop from HP. Its cutting-edge technology and high-end specifications make it your ideal companion, allowing you to overcome any challenge. Powered by 8 GB of RAM and a 2.3 GHz Core i3 7th Gen processor, this laptop also features an Intel Integrated HD 620 graphics processor and the DOS operating system, providing you with a seamless performance no matter what you do.")
        
        productList.append(iphoneX)
        productList.append(hpLaptop)

    }
    
    private func storeProductInDB() {
        for product in productList {
                ProductRepository().saveServicesInDB(product: product)
        }
    }

}


// Model for DB version 1

class ProductInfo {
    
    var name: String = ""
    var id: String = ""
    var descriptions: String = ""
    
     init(name: String, id: String, description: String) {
        self.name = name
        self.id = id
        self.descriptions = description
    }
    
}
