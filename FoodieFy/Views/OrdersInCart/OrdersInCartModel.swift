//
//  OrdersInCartModel.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 31.08.23.
//

import Foundation
import ProgressHUD
import Firebase

struct OrdersInCartModel {
    
    private let dataBase = Firestore.firestore()
    
    func calculateSum(orders:[OrderFS]) -> String {
        var sum: Double = 0
        orders.forEach{
            if let itemPrice = $0.price, let itemQuantity = $0.quantity {
                let sumPerItem = itemPrice * itemQuantity
                sum += sumPerItem
            }
        }
        let sumStr = String(format: "%.1f", sum)
        return sumStr
    }
    
    func clearOrders(orders:[OrderFS]) {
        for order in orders {
            if let docID = order.documentID {
                dataBase.collection(K.FirestoreCollections.order).document(docID).delete() {
                error in
                    if let err = error {
                        ProgressHUD.showError(err.localizedDescription)
                    }
                }
            }
        }
    }
    
}
