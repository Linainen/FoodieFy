//
//  Constants.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 25.08.23.
//

import Foundation

struct K {
    
    struct FirestoreCollections {
        static let category: String = "category"
        static let plate: String = "plate"
        static let order: String = "order"
        static let delivery: String = "delivery"
    }
    
    struct OrderParams {
        static let name: String = "name"
        static let quantity: String = "quantity"
        static let price: String = "price"
        static let user: String = "user"
        static let documentID: String = "documentID"
     }
    
    struct CategoryParams {
        static let name = "name"
    }
    
    struct PlateParams {
        static let name = "name"
        static let category = "category"
        static let image = "image"
        static let description = "description"
        static let price = "price"
        static let new = "isNew"
        static let popular = "isPopular"
    }

}
