//
//  FirebaseService.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 31.08.23.
//

import Foundation
import Firebase
import ProgressHUD

class FirebaseService {
    
    static let shared = FirebaseService()
    
    private let dataBase = Firestore.firestore()
    
    enum DishType {
        case popular, new
    }
    
    private init(){
        
    }
    
    func fetchCategories() async throws -> [CategoryFS] {
        let snapshot = try await dataBase.collection(K.FirestoreCollections.category).getDocuments()
        var categories:[CategoryFS] = []
        let snapshotDocuments = snapshot.documents
        for document in snapshotDocuments {
            let data = document.data()
            if let categoryName = data[K.CategoryParams.name] as? String {
                let newCategory = CategoryFS(name: categoryName)
                categories.append(newCategory)
            }
        }
        return categories
    }
    
    func fetchPopularAndNew(dish: DishType) async throws -> [DishFS] {
        let snapshot = try await dataBase.collection(K.FirestoreCollections.plate).getDocuments()
        var dishes:[DishFS] = []
        let snapshotDocuments = snapshot.documents
        for document in snapshotDocuments {
            let data = document.data()
            if let plateName = data[K.PlateParams.name] as? String, let platePrice = data[K.PlateParams.price] as? Double, let plateDescription = data[K.PlateParams.description] as? String, let plateCategory = data[K.PlateParams.category] as? String, let isPopular = data[K.PlateParams.popular] as? Bool, let isNew = data[K.PlateParams.new] as? Bool {
                let newPlate = DishFS(name: plateName, description: plateDescription, category: plateCategory, price: platePrice, isPopular: isPopular, isNew: isNew)
                dishes.append(newPlate)
            }
        }
        switch dish {
        case .popular:
            dishes = dishes.filter{ $0.isPopular == true }
        case .new:
            dishes = dishes.filter{ $0.isNew == true }
        }
        return dishes
    }
    
    func fetchDishesByCategory(category: String?) async throws -> [DishFS] {
        let snapshot = try await dataBase.collection(K.FirestoreCollections.plate).getDocuments()
        var dishes:[DishFS] = []
        let snapshotDocuments = snapshot.documents
        for document in snapshotDocuments {
            let data = document.data()
            if let plateName = data[K.PlateParams.name] as? String, let platePrice = data[K.PlateParams.price] as? Double, let plateDescription = data[K.PlateParams.description] as? String, let plateCategory = data[K.PlateParams.category] as? String {
                let newPlate = DishFS(name: plateName, description: plateDescription, category: plateCategory, price: platePrice)
                dishes.append(newPlate)
            }
        }
        dishes = dishes.filter{$0.category == category}
        return dishes
    }
    
}
