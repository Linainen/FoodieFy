//
//  DishDetailsModel.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 31.08.23.
//

import Foundation
import Firebase
import ProgressHUD

struct DishDetailsModel {
    
    private let dataBase = Firestore.firestore()
    
    func addOrderToFirestore(plateName: String, platePrice: Double, userPhone: String, plateQuantity: String){
        dataBase.collection(K.FirestoreCollections.order).document().setData([
            "name": plateName,
            "user": userPhone,
            "price": platePrice,
            "quantity": Int(plateQuantity) ?? 1
        ]) {error in
            if let err = error {
                ProgressHUD.showError(err.localizedDescription)
            } else {
                ProgressHUD.showSucceed("Dish added to cart!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    ProgressHUD.dismiss()
                }
            }
        }
    }
    
}
