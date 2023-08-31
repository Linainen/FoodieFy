//
//  DeliveryDetailsModel.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 29.08.23.
//

import Foundation
import Firebase
import FirebaseFirestore
import ProgressHUD

protocol DeliveryDetailsDelegate {
    func orderCompleted()
}

struct DeliveryDetailsModel {
    
    private let dataBase = Firestore.firestore()
    
    func fetchDelivery(userName: String, userAdress: String, userPhoneNumber: String, orders: [OrderFS]){
        
        var totalPriсe: Double = 0
        var plateNamesWithQuantity: [String : String] = [:]
        
        orders.forEach{
            if let itemPrice = $0.price, let itemQuantity = $0.quantity, let itemName = $0.name {
                let sumPerItem = itemPrice * itemQuantity
                totalPriсe += sumPerItem
                let quantityStr = String(format: "%.0f", itemQuantity)
                plateNamesWithQuantity[itemName] = quantityStr
            }
        }
        
        let sumString = String(format: "%.1f", totalPriсe)
        
        dataBase.collection(K.FirestoreCollections.delivery).document().setData([
            "user" : userName,
            "phoneNumber" : userPhoneNumber,
            "adress" : userAdress,
            "totalPrice" : sumString,
            "dishesOrdered" : plateNamesWithQuantity
        ]) {error in
            if let err = error {
                ProgressHUD.showError(err.localizedDescription)
            }
        }
    }
}
