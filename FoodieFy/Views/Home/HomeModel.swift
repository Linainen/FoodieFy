//
//  HomeModel.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 31.08.23.
//

import Foundation
import Firebase
import ProgressHUD

class HomeModel {
    
    private let dataBase = Firestore.firestore()
    
    func fetchCategories() -> [CategoryFS] {
        
        var categories: [CategoryFS] = []
        
        Task.init {
            categories = try await FirebaseService.shared.fetchCategories()
        }
        
        return categories
    }
    
    
    
}
